import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:growth_flutter_fase_05_riverpood/core/enums/app_failure_type.dart';
import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/event.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/reservation.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/reservation_with_details.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/ticket.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/event_status.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/reservation_status.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/ticket_status.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/my_reservations/my_reservations_notifier.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/my_reservations/my_reservations_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/my_reservations/states/my_reservations_error_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/my_reservations/states/my_reservations_loaded_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/my_reservations/states/my_reservations_loading_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservations/confirm_purchase_notifier.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservations/confirm_purchase_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservations/states/confirm_purchase_error_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservations/states/confirm_purchase_initial_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservations/states/confirm_purchase_loading_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservations/states/confirm_purchase_success_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/container.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/screens/my_reservations/my_reservations_page.dart';

void main() {
  testWidgets('shows a pending reservation and its purchase action', (
    tester,
  ) async {
    final event = _createEvent();
    final reservation = _createPendingReservation(event.id);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          myReservationsNotifierProvider.overrideWith(
            () => _MyReservationsPageLoadedTestNotifier([
              ReservationWithDetails(reservation: reservation, event: event),
            ]),
          ),
        ],
        child: const MaterialApp(home: MyReservationsPage()),
      ),
    );

    expect(find.text('Mis reservas'), findsOneWidget);
    expect(find.text('Torneo de vóley'), findsOneWidget);
    expect(find.text('pendiente'), findsOneWidget);
    expect(find.text('15/11/2026 · Gimnasio Central, Lima'), findsOneWidget);
    expect(find.text('Cupos reservados: 1'), findsOneWidget);
    expect(find.text('Confirmar compra'), findsOneWidget);
  });

  testWidgets('shows a loader while confirming the purchase', (tester) async {
    final event = _createEvent();
    final reservation = _createPendingReservation(event.id);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          myReservationsNotifierProvider.overrideWith(
            () => _MyReservationsPageLoadedTestNotifier([
              ReservationWithDetails(reservation: reservation, event: event),
            ]),
          ),
          confirmPurchaseNotifierProvider.overrideWith(
            _ConfirmPurchaseLoadingTestNotifier.new,
          ),
        ],
        child: const MaterialApp(home: MyReservationsPage()),
      ),
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Confirmar compra'));
    await tester.pump();

    expect(find.text('Confirmando compra...'), findsOneWidget);
    expect(find.text('Confirmar compra'), findsNothing);
  });

  testWidgets('shows purchase error and keeps the action available', (
    tester,
  ) async {
    final event = _createEvent();
    final reservation = _createPendingReservation(event.id);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          myReservationsNotifierProvider.overrideWith(
            () => _MyReservationsPageLoadedTestNotifier([
              ReservationWithDetails(reservation: reservation, event: event),
            ]),
          ),
          confirmPurchaseNotifierProvider.overrideWith(
            _ConfirmPurchaseErrorTestNotifier.new,
          ),
        ],
        child: const MaterialApp(home: MyReservationsPage()),
      ),
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Confirmar compra'));
    await tester.pump();

    expect(
      find.text('No se pudo confirmar la compra. Inténtalo nuevamente.'),
      findsOneWidget,
    );
    expect(find.text('Confirmando compra...'), findsNothing);
    final confirmButton = find.widgetWithText(FilledButton, 'Confirmar compra');
    expect(confirmButton, findsOneWidget);
    expect(tester.widget<FilledButton>(confirmButton).onPressed, isNotNull);
  });

  testWidgets('shows the ticket after a successful purchase', (tester) async {
    final event = _createEvent();
    final pendingReservation = _createPendingReservation(event.id);
    final purchasedReservation = ReservationWithDetails(
      reservation: Reservation(
        id: pendingReservation.id,
        userId: pendingReservation.userId,
        eventId: pendingReservation.eventId,
        seatCount: pendingReservation.seatCount,
        status: ReservationStatus.confirmed,
        reservedAt: pendingReservation.reservedAt,
      ),
      event: event,
      ticket: Ticket(
        id: 'ticket-1',
        reservationId: pendingReservation.id,
        code: 'TKT-2026-001',
        status: TicketStatus.valid,
        createdAt: DateTime(2026, 11),
      ),
    );
    final reservationsNotifier = _MyReservationsPagePurchaseTestNotifier(
      pendingReservation: ReservationWithDetails(
        reservation: pendingReservation,
        event: event,
      ),
      purchasedReservation: purchasedReservation,
    );
    final confirmPurchaseNotifier = _ConfirmPurchaseSuccessTestNotifier();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          myReservationsNotifierProvider.overrideWith(
            () => reservationsNotifier,
          ),
          confirmPurchaseNotifierProvider.overrideWith(
            () => confirmPurchaseNotifier,
          ),
        ],
        child: const MaterialApp(home: MyReservationsPage()),
      ),
    );
    await tester.pump();

    await tester.tap(find.widgetWithText(FilledButton, 'Confirmar compra'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(
      confirmPurchaseNotifier.requestedReservationId,
      pendingReservation.id,
    );
    expect(find.text('Compra confirmada correctamente'), findsOneWidget);
    expect(find.text('confirmada'), findsOneWidget);
    expect(find.text('Código de ticket: TKT-2026-001'), findsOneWidget);
    expect(find.text('Confirmar compra'), findsNothing);
  });

  testWidgets('guides the user when there are no reservations', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          myReservationsNotifierProvider.overrideWith(
            () => _MyReservationsPageLoadedTestNotifier(const []),
          ),
        ],
        child: const MaterialApp(home: MyReservationsPage()),
      ),
    );

    expect(find.text('Aún no tienes reservas'), findsOneWidget);
    expect(
      find.text('Explora los eventos disponibles y reserva tu cupo.'),
      findsOneWidget,
    );
    expect(find.text('Ver eventos'), findsOneWidget);
    expect(find.text('Cargando tus reservas...'), findsNothing);
  });

  testWidgets('retries loading reservations after a connection error', (
    tester,
  ) async {
    final reservationsNotifier = _MyReservationsPageRetryTestNotifier();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          myReservationsNotifierProvider.overrideWith(
            () => reservationsNotifier,
          ),
        ],
        child: const MaterialApp(home: MyReservationsPage()),
      ),
    );
    await tester.pump();

    expect(find.text('No se pudo conectar con el servidor.'), findsOneWidget);
    expect(find.text('Reintentar'), findsOneWidget);

    await tester.tap(find.text('Reintentar'));
    await tester.pump();

    expect(reservationsNotifier.loadCalls, 2);
    expect(find.text('Cargando tus reservas...'), findsOneWidget);
    expect(find.text('Reintentar'), findsNothing);
  });
}

Event _createEvent() {
  return Event(
    id: 'event-1',
    name: 'Torneo de vóley',
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

Reservation _createPendingReservation(String eventId) {
  return Reservation(
    id: 'reservation-1',
    userId: 'user-1',
    eventId: eventId,
    seatCount: 1,
    status: ReservationStatus.pending,
    reservedAt: DateTime(2026, 11),
  );
}

final class _MyReservationsPageLoadedTestNotifier
    extends MyReservationsNotifier {
  _MyReservationsPageLoadedTestNotifier(this.reservations);

  final List<ReservationWithDetails> reservations;

  @override
  MyReservationsState build() {
    return MyReservationsLoadedState(reservations: reservations);
  }

  @override
  Future<void> loadMyReservations() async {}
}

final class _MyReservationsPageRetryTestNotifier
    extends MyReservationsNotifier {
  int loadCalls = 0;

  @override
  MyReservationsState build() {
    return const MyReservationsErrorState(
      AppFailure(
        failureType: AppFailureType.network,
        message: 'No se pudo conectar con el servidor.',
      ),
    );
  }

  @override
  Future<void> loadMyReservations() async {
    loadCalls++;
    if (loadCalls > 1) {
      state = const MyReservationsLoadingState();
    }
  }
}

final class _MyReservationsPagePurchaseTestNotifier
    extends MyReservationsNotifier {
  _MyReservationsPagePurchaseTestNotifier({
    required this.pendingReservation,
    required this.purchasedReservation,
  });

  final ReservationWithDetails pendingReservation;
  final ReservationWithDetails purchasedReservation;
  var _loadCalls = 0;

  @override
  MyReservationsState build() {
    return MyReservationsLoadedState(reservations: [pendingReservation]);
  }

  @override
  Future<void> loadMyReservations() async {
    _loadCalls++;
    if (_loadCalls > 1) {
      state = MyReservationsLoadedState(reservations: [purchasedReservation]);
    }
  }
}

final class _ConfirmPurchaseLoadingTestNotifier
    extends ConfirmPurchaseNotifier {
  @override
  ConfirmPurchaseState build() => const ConfirmPurchaseInitialState();

  @override
  Future<void> onConfirmPurchase(String reservationId) async {
    state = ConfirmPurchaseLoadingState(reservationId);
  }
}

final class _ConfirmPurchaseErrorTestNotifier extends ConfirmPurchaseNotifier {
  @override
  ConfirmPurchaseState build() => const ConfirmPurchaseInitialState();

  @override
  Future<void> onConfirmPurchase(String reservationId) async {
    state = ConfirmPurchaseErrorState(
      reservationId: reservationId,
      failure: const AppFailure(
        failureType: AppFailureType.network,
        message: 'No se pudo confirmar la compra. Inténtalo nuevamente.',
      ),
    );
  }
}

final class _ConfirmPurchaseSuccessTestNotifier
    extends ConfirmPurchaseNotifier {
  String? requestedReservationId;

  @override
  ConfirmPurchaseState build() => const ConfirmPurchaseInitialState();

  @override
  Future<void> onConfirmPurchase(String reservationId) async {
    requestedReservationId = reservationId;
    state = ConfirmPurchaseSuccessState(reservationId);
  }
}
