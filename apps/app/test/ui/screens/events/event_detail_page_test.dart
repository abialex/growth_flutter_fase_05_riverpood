import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:growth_flutter_fase_05_riverpood/core/enums/app_failure_type.dart';
import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/event.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/reservation_eligibility.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/event_status.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/reservation_eligibility_status.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/event_detail/event_detail_notifier.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/event_detail/event_detail_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/event_detail/states/event_detail_loaded_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/events/events_notifier.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/events/events_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/events/states/events_initial_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservations/create_reservation_notifier.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservations/create_reservation_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservations/states/create_reservation_error_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservations/states/create_reservation_initial_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservations/states/create_reservation_loading_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservations/states/create_reservation_success_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/container.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/screens/events/event_detail_page.dart';

void main() {
  testWidgets('shows event details and the reservation action when available', (
    tester,
  ) async {
    final event = _createEvent();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          eventDetailNotifierProvider(event.id).overrideWith(
            () => _EventDetailPageLoadedTestNotifier(event),
          ),
        ],
        child: MaterialApp(home: EventDetailPage(eventId: event.id)),
      ),
    );

    expect(find.text('Detalle del evento'), findsOneWidget);
    expect(find.text('Torneo de vóley'), findsOneWidget);
    expect(find.text('Vóley'), findsOneWidget);
    expect(find.text('15/11/2026 · 19:30'), findsOneWidget);
    expect(find.text('Gimnasio Central, Lima'), findsOneWidget);
    expect(find.text('8 disponibles de 20'), findsOneWidget);
    expect(find.text('abierto'), findsOneWidget);
    expect(find.text('Final de temporada.'), findsOneWidget);
    expect(find.text('Reservar cupo'), findsOneWidget);
  });

  testWidgets('blocks reservation when the user already has a ticket', (
    tester,
  ) async {
    final event = _createEvent();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          eventDetailNotifierProvider(event.id).overrideWith(
            () => _EventDetailPagePurchasedTicketTestNotifier(event),
          ),
        ],
        child: MaterialApp(home: EventDetailPage(eventId: event.id)),
      ),
    );

    expect(
      find.text('Ya compraste un ticket para este evento.'),
      findsOneWidget,
    );
    expect(find.text('Reservar cupo'), findsNothing);
  });

  testWidgets('shows a loader while creating a reservation', (tester) async {
    final event = _createEvent();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          eventDetailNotifierProvider(event.id).overrideWith(
            () => _EventDetailPageLoadedTestNotifier(event),
          ),
          createReservationNotifierProvider.overrideWith(
            _CreateReservationLoadingTestNotifier.new,
          ),
        ],
        child: MaterialApp(home: EventDetailPage(eventId: event.id)),
      ),
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Reservar cupo'));
    await tester.pump();

    expect(find.text('Procesando reserva...'), findsOneWidget);
    expect(find.text('Reservar cupo'), findsNothing);
  });

  testWidgets('shows reservation error and keeps the action available', (
    tester,
  ) async {
    final event = _createEvent();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          eventDetailNotifierProvider(event.id).overrideWith(
            () => _EventDetailPageLoadedTestNotifier(event),
          ),
          createReservationNotifierProvider.overrideWith(
            _CreateReservationErrorTestNotifier.new,
          ),
        ],
        child: MaterialApp(home: EventDetailPage(eventId: event.id)),
      ),
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Reservar cupo'));
    await tester.pump();

    expect(
      find.text('No se pudo crear la reserva. Inténtalo nuevamente.'),
      findsOneWidget,
    );
    expect(find.text('Procesando reserva...'), findsNothing);
    final reserveButton = find.widgetWithText(FilledButton, 'Reservar cupo');
    expect(reserveButton, findsOneWidget);
    expect(tester.widget<FilledButton>(reserveButton).onPressed, isNotNull);
  });

  testWidgets('refreshes event details after a successful reservation', (
    tester,
  ) async {
    final event = _createEvent();
    final detailNotifier = _EventDetailPageReservedAfterRetryTestNotifier(
      event,
    );
    final eventsNotifier = _EventsPageRefreshTestNotifier();
    final createReservationNotifier = _CreateReservationSuccessTestNotifier();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          eventDetailNotifierProvider(event.id).overrideWith(
            () => detailNotifier,
          ),
          eventsNotifierProvider.overrideWith(() => eventsNotifier),
          createReservationNotifierProvider.overrideWith(
            () => createReservationNotifier,
          ),
        ],
        child: MaterialApp(home: EventDetailPage(eventId: event.id)),
      ),
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Reservar cupo'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(createReservationNotifier.requestedEventId, event.id);
    expect(createReservationNotifier.requestedSeatCount, 1);
    expect(find.text('Reserva creada correctamente'), findsOneWidget);
    expect(detailNotifier.retryCalls, 1);
    expect(eventsNotifier.loadEventsCalls, 1);
    expect(
      find.text('Ya tienes una reserva para este evento.'),
      findsOneWidget,
    );
    expect(find.text('Reservar cupo'), findsNothing);
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
    description: 'Final de temporada.',
  );
}

final class _EventDetailPageLoadedTestNotifier extends EventDetailNotifier {
  _EventDetailPageLoadedTestNotifier(this.event) : super(event.id);

  final Event event;

  @override
  EventDetailState build() {
    return EventDetailLoadedState(
      event: event,
      reservationEligibility: const ReservationEligibility(
        status: ReservationEligibilityStatus.available,
      ),
    );
  }
}

final class _EventDetailPagePurchasedTicketTestNotifier
    extends EventDetailNotifier {
  _EventDetailPagePurchasedTicketTestNotifier(this.event) : super(event.id);

  final Event event;

  @override
  EventDetailState build() {
    return EventDetailLoadedState(
      event: event,
      reservationEligibility: const ReservationEligibility(
        status: ReservationEligibilityStatus.ticketPurchased,
      ),
    );
  }
}

final class _EventDetailPageReservedAfterRetryTestNotifier
    extends EventDetailNotifier {
  _EventDetailPageReservedAfterRetryTestNotifier(this.event) : super(event.id);

  final Event event;
  int retryCalls = 0;

  @override
  EventDetailState build() {
    return EventDetailLoadedState(
      event: event,
      reservationEligibility: const ReservationEligibility(
        status: ReservationEligibilityStatus.available,
      ),
    );
  }

  @override
  Future<void> onRetry() async {
    retryCalls++;
    state = EventDetailLoadedState(
      event: event,
      reservationEligibility: const ReservationEligibility(
        status: ReservationEligibilityStatus.alreadyReserved,
      ),
    );
  }
}

final class _EventsPageRefreshTestNotifier extends EventsNotifier {
  int loadEventsCalls = 0;

  @override
  EventsState build() => const EventsInitialState();

  @override
  Future<void> loadEvents() async {
    loadEventsCalls++;
  }
}

final class _CreateReservationLoadingTestNotifier
    extends CreateReservationNotifier {
  @override
  CreateReservationState build() => const CreateReservationInitialState();

  @override
  Future<void> onCreateReservation({
    required String eventId,
    required int seatCount,
  }) async {
    state = const CreateReservationLoadingState();
  }
}

final class _CreateReservationErrorTestNotifier
    extends CreateReservationNotifier {
  @override
  CreateReservationState build() => const CreateReservationInitialState();

  @override
  Future<void> onCreateReservation({
    required String eventId,
    required int seatCount,
  }) async {
    state = const CreateReservationErrorState(
      AppFailure(
        failureType: AppFailureType.network,
        message: 'No se pudo crear la reserva. Inténtalo nuevamente.',
      ),
    );
  }
}

final class _CreateReservationSuccessTestNotifier
    extends CreateReservationNotifier {
  String? requestedEventId;
  int? requestedSeatCount;

  @override
  CreateReservationState build() => const CreateReservationInitialState();

  @override
  Future<void> onCreateReservation({
    required String eventId,
    required int seatCount,
  }) async {
    requestedEventId = eventId;
    requestedSeatCount = seatCount;
    state = const CreateReservationSuccessState();
  }
}
