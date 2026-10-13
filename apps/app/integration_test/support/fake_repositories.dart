import 'dart:async';

import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/event.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/reservation.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/reservation_with_details.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/auth_status.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/event_status.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/reservation_status.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/auth_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/events_repository.dart';
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

  bool _isAuthenticated;
  String? lastEmail;
  String? lastPassword;

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
  }) async =>
      throw UnimplementedError();
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
