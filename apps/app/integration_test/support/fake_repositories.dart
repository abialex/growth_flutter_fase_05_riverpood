import 'dart:async';

import 'package:growth_flutter_fase_05_riverpood/core/enums/app_failure_type.dart';
import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/event.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/reservation.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/reservation_with_details.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/ticket.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/auth_status.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/event_status.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/reservation_status.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/ticket_status.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/auth_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/events_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/purchase_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/reservations_repository.dart';

Event buildSampleEvent() {
  return Event(
    id: 'event-1',
    name: 'Copa de prueba',
    sport: 'Vóley',
    date: DateTime(2026, 11, 15),
    time: '19:30:00',
    city: 'Lima',
    venue: 'Gimnasio Central',
    totalSlots: 20,
    availableSlots: 8,
    status: EventStatus.open,
  );
}

final class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({bool isAuthenticated = false})
    : _isAuthenticated = isAuthenticated;

  final StreamController<AuthStatus> _authStatusController =
      StreamController<AuthStatus>.broadcast();
  final Completer<void> _signInStarted = Completer<void>();
  final Completer<void> _finishSignIn = Completer<void>();
  final Completer<void> _signUpStarted = Completer<void>();
  final Completer<void> _finishSignUp = Completer<void>();

  bool _isAuthenticated;
  String? lastEmail;
  String? lastPassword;
  String? lastSignUpEmail;
  String? lastSignUpPassword;
  String? lastSignUpName;
  String? lastSignUpCity;

  @override
  bool get isAuthenticated => _isAuthenticated;

  @override
  Stream<AuthStatus> get authStatusChanges => _authStatusController.stream;

  @override
  Future<Result<void, AppFailure>> signIn({
    required String email,
    required String password,
  }) async {
    lastEmail = email;
    lastPassword = password;
    _signInStarted.complete();
    await _finishSignIn.future;
    _isAuthenticated = true;
    _authStatusController.add(AuthStatus.authenticated);
    return const Success<void, AppFailure>(null);
  }

  Future<void> finishSignIn() async {
    await _signInStarted.future;
    _finishSignIn.complete();
  }

  Future<void> dispose() => _authStatusController.close();

  @override
  Future<Result<void, AppFailure>> signOut() async =>
      throw UnimplementedError();

  @override
  Future<Result<void, AppFailure>> signUp({
    required String email,
    required String password,
    required String name,
    String? city,
  }) async {
    lastSignUpEmail = email;
    lastSignUpPassword = password;
    lastSignUpName = name;
    lastSignUpCity = city;
    _signUpStarted.complete();
    await _finishSignUp.future;
    return const Success<void, AppFailure>(null);
  }

  Future<void> finishSignUp() async {
    await _signUpStarted.future;
    _finishSignUp.complete();
  }
}

final class FakeEventsRepository implements EventsRepository {
  FakeEventsRepository(this.events);

  final List<Event> events;

  @override
  Future<Result<List<Event>, AppFailure>> getEvents() async =>
      Success<List<Event>, AppFailure>(events);

  @override
  Future<Result<Event, AppFailure>> getEventById(String id) async =>
      Success<Event, AppFailure>(events.firstWhere((event) => event.id == id));
}

final class FakeReservationsRepository implements ReservationsRepository {
  FakeReservationsRepository({required this.event});

  final Event event;
  final Completer<void> _reservationStarted = Completer<void>();
  final Completer<void> _finishReservation = Completer<void>();
  final List<ReservationWithDetails> _reservations = [];

  String? lastEventId;
  int? lastSeatCount;

  @override
  Future<Result<Reservation, AppFailure>> createReservation({
    required String eventId,
    required int seatCount,
  }) async {
    lastEventId = eventId;
    lastSeatCount = seatCount;
    _reservationStarted.complete();
    await _finishReservation.future;

    final reservation = Reservation(
      id: 'reservation-1',
      userId: 'user-1',
      eventId: eventId,
      seatCount: seatCount,
      status: ReservationStatus.pending,
      reservedAt: DateTime(2026, 10, 13),
    );
    _reservations.add(
      ReservationWithDetails(reservation: reservation, event: event),
    );
    return Success<Reservation, AppFailure>(reservation);
  }

  Future<void> finishCreateReservation() async {
    await _reservationStarted.future;
    _finishReservation.complete();
  }

  void seedPendingReservation({
    required String reservationId,
    required int seatCount,
  }) {
    final reservation = Reservation(
      id: reservationId,
      userId: 'user-1',
      eventId: event.id,
      seatCount: seatCount,
      status: ReservationStatus.pending,
      reservedAt: DateTime(2026, 10, 13),
    );
    _reservations.add(
      ReservationWithDetails(reservation: reservation, event: event),
    );
  }

  void confirmReservation({
    required String reservationId,
    required Ticket ticket,
  }) {
    final index = _reservations.indexWhere(
      (details) => details.reservation.id == reservationId,
    );
    if (index < 0) {
      throw StateError('Reservation $reservationId was not found.');
    }

    final details = _reservations[index];
    final reservation = details.reservation;
    _reservations[index] = ReservationWithDetails(
      reservation: Reservation(
        id: reservation.id,
        userId: reservation.userId,
        eventId: reservation.eventId,
        seatCount: reservation.seatCount,
        status: ReservationStatus.confirmed,
        reservedAt: reservation.reservedAt,
      ),
      event: details.event,
      ticket: ticket,
    );
  }

  @override
  Future<Result<List<Reservation>, AppFailure>> getMyReservations() async =>
      Success<List<Reservation>, AppFailure>(
        _reservations.map((details) => details.reservation).toList(),
      );

  @override
  Future<Result<List<ReservationWithDetails>, AppFailure>>
  getMyReservationsWithDetails() async =>
      Success<List<ReservationWithDetails>, AppFailure>(_reservations);
}

final class FakePurchaseRepository implements PurchaseRepository {
  FakePurchaseRepository({
    required this.reservationsRepository,
    this.failFirstAttempt = false,
  });

  final FakeReservationsRepository reservationsRepository;
  final bool failFirstAttempt;
  final Completer<void> _purchaseStarted = Completer<void>();
  final Completer<void> _finishPurchase = Completer<void>();

  String? lastReservationId;
  int confirmCalls = 0;

  @override
  Future<Result<Ticket, AppFailure>> confirmPurchase(
    String reservationId,
  ) async {
    lastReservationId = reservationId;
    confirmCalls++;
    if (failFirstAttempt && confirmCalls == 1) {
      return const Failure<Ticket, AppFailure>(
        AppFailure(
          failureType: AppFailureType.network,
          message: 'No se pudo confirmar la compra. Inténtalo nuevamente.',
        ),
      );
    }

    _purchaseStarted.complete();
    await _finishPurchase.future;

    final ticket = Ticket(
      id: 'ticket-1',
      reservationId: reservationId,
      code: 'TICKET-TEST-001',
      status: TicketStatus.valid,
      createdAt: DateTime(2026, 10, 13),
    );
    reservationsRepository.confirmReservation(
      reservationId: reservationId,
      ticket: ticket,
    );
    return Success<Ticket, AppFailure>(ticket);
  }

  Future<void> finishConfirmPurchase() async {
    await _purchaseStarted.future;
    _finishPurchase.complete();
  }
}
