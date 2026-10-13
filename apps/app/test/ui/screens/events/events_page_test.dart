import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:growth_flutter_fase_05_riverpood/core/enums/app_failure_type.dart';
import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/event.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/event_filters.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/event_reservation_status.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/event_status.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/events/events_notifier.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/events/events_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/events/states/events_initial_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/events/states/events_loaded_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/events/states/events_error_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/events/states/events_loading_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/container.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/screens/events/events_page.dart';

void main() {
  testWidgets('renders the events page while events are loading', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          eventsNotifierProvider.overrideWith(
            _EventsPageTestNotifier.new,
          ),
        ],
        child: const MaterialApp(home: EventsPage()),
      ),
    );
    await tester.pump();

    expect(find.text('Eventos'), findsOneWidget);
    expect(find.text('Cargando eventos...'), findsOneWidget);
    expect(find.byTooltip('Mis reservas'), findsOneWidget);
    expect(find.byTooltip('Cerrar sesión'), findsOneWidget);
  });

  testWidgets('shows purchased and reserved markers on loaded events', (
    tester,
  ) async {
    final event = _createEvent('event-1', 'Torneo de vóley');

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          eventsNotifierProvider.overrideWith(
            () => _EventsPageLoadedTestNotifier(event),
          ),
        ],
        child: const MaterialApp(home: EventsPage()),
      ),
    );
    await tester.pump();

    expect(find.text('Eventos'), findsOneWidget);
    expect(find.text('Torneo de vóley'), findsOneWidget);
    expect(find.text('Otro evento'), findsOneWidget);
    // expect(find.text('15/11/2026 · 19:30'), findsOneWidget);
    // expect(find.text('Gimnasio Central, Lima'), findsOneWidget);
    // expect(find.text('Cupos: 8/20'), findsOneWidget);
    expect(find.text('Comprado'), findsOneWidget);
    expect(find.text('Reservado'), findsOneWidget);
  });

  testWidgets('retries loading events after a recoverable error', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          eventsNotifierProvider.overrideWith(
            _EventsPageRetryTestNotifier.new,
          ),
        ],
        child: const MaterialApp(home: EventsPage()),
      ),
    );
    await tester.pump();

    expect(find.text('No se pudo conectar con el servidor.'), findsOneWidget);
    expect(find.text('Reintentar'), findsOneWidget);

    await tester.tap(find.text('Reintentar'));
    await tester.pump();

    expect(find.text('Cargando eventos...'), findsOneWidget);
    expect(find.text('Reintentar'), findsNothing);
  });

  testWidgets('hides retry for a non-recoverable error', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          eventsNotifierProvider.overrideWith(
            _EventsPageNonRetryableErrorTestNotifier.new,
          ),
        ],
        child: const MaterialApp(home: EventsPage()),
      ),
    );
    await tester.pump();

    expect(
      find.text('No tienes permisos para realizar esta operación.'),
      findsOneWidget,
    );
    expect(find.text('Reintentar'), findsNothing);
  });

  testWidgets('shows an empty state when there are no published events', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          eventsNotifierProvider.overrideWith(
            _EventsPageEmptyTestNotifier.new,
          ),
        ],
        child: const MaterialApp(home: EventsPage()),
      ),
    );
    await tester.pump();

    expect(find.text('No hay eventos disponibles'), findsOneWidget);
    expect(
      find.text('Todavía no hay eventos publicados. Vuelve pronto.'),
      findsOneWidget,
    );
    expect(find.text('Cargando eventos...'), findsNothing);
  });

  testWidgets('clears filters when no events match the selected filters', (
    tester,
  ) async {
    final limaVolleyballEvent = _createEvent(
      'event-lima',
      'Vóley en Lima',
    );
    final cuscoFootballEvent = _createEvent(
      'event-cusco',
      'Fútbol en Cusco',
      sport: 'Fútbol',
      city: 'Cusco',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          eventsNotifierProvider.overrideWith(
            () => _EventsPageFilterTestNotifier([
              limaVolleyballEvent,
              cuscoFootballEvent,
            ]),
          ),
        ],
        child: const MaterialApp(home: EventsPage()),
      ),
    );
    await tester.pump();

    expect(find.text('Vóley en Lima'), findsOneWidget);
    expect(find.text('Fútbol en Cusco'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilterChip, 'Vóley'));
    await tester.pump();
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cusco'));
    await tester.pumpAndSettle();

    expect(
      find.text('No hay eventos que coincidan con los filtros'),
      findsOneWidget,
    );
    expect(find.text('Vóley en Lima'), findsNothing);
    expect(find.text('Fútbol en Cusco'), findsNothing);

    await tester.tap(find.text('Limpiar filtros').last);
    await tester.pump();

    expect(
      find.text('No hay eventos que coincidan con los filtros'),
      findsNothing,
    );
    expect(find.text('Vóley en Lima'), findsOneWidget);
    expect(find.text('Fútbol en Cusco'), findsOneWidget);
    expect(find.text('Limpiar filtros'), findsNothing);
  });
}

final class _EventsPageTestNotifier extends EventsNotifier {
  @override
  EventsState build() => const EventsInitialState();

  @override
  Future<void> loadEvents() async {}
}

Event _createEvent(
  String id,
  String name, {
  String sport = 'Vóley',
  String city = 'Lima',
}) {
  return Event(
    id: id,
    name: name,
    sport: sport,
    date: DateTime(2026, 11, 15),
    time: '19:30:00',
    city: city,
    venue: 'Gimnasio Central',
    totalSlots: 20,
    availableSlots: 8,
    status: EventStatus.open,
  );
}

final class _EventsPageLoadedTestNotifier extends EventsNotifier {
  _EventsPageLoadedTestNotifier(this.event);

  final Event event;

  @override
  EventsState build() {
    final otherEvent = _createEvent('event-2', 'Otro evento');
    return EventsLoadedState(
      [event, otherEvent],
      filteredEvents: [event, otherEvent],
      eventReservationStatuses: {
        event.id: EventReservationStatus.purchased,
        otherEvent.id: EventReservationStatus.reserved,
      },
    );
  }

  @override
  Future<void> loadEvents() async {}
}

final class _EventsPageRetryTestNotifier extends EventsNotifier {
  var _loadEventsCalls = 0;

  @override
  EventsState build() => const EventsErrorState(
    AppFailure(
      failureType: AppFailureType.network,
      message: 'No se pudo conectar con el servidor.',
    ),
  );

  @override
  Future<void> loadEvents() async {
    _loadEventsCalls++;
    if (_loadEventsCalls > 1) {
      state = const EventsLoadingState();
    }
  }
}

final class _EventsPageNonRetryableErrorTestNotifier extends EventsNotifier {
  @override
  EventsState build() => const EventsErrorState(
    AppFailure(
      failureType: AppFailureType.unauthorized,
      message: 'No tienes permisos para realizar esta operación.',
    ),
  );

  @override
  Future<void> loadEvents() async {}
}

final class _EventsPageEmptyTestNotifier extends EventsNotifier {
  @override
  EventsState build() => const EventsLoadedState([], filteredEvents: []);

  @override
  Future<void> loadEvents() async {}
}

final class _EventsPageFilterTestNotifier extends EventsNotifier {
  _EventsPageFilterTestNotifier(this.events);

  final List<Event> events;

  @override
  EventsState build() => EventsLoadedState(events, filteredEvents: events);

  @override
  void onApplyFilters(EventFilters filters) {
    state = EventsLoadedState(
      events,
      filteredEvents: events.where(filters.matches).toList(),
    );
  }

  @override
  Future<void> loadEvents() async {}
}
