import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:growth_flutter_fase_05_riverpood/core/enums/app_failure_type.dart';
import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/event.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/event_filters.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/event_status.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/events_data.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/use_case.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/events/states/events_error_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/events/states/events_loaded_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/events/states/events_loading_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/event_providers.dart';
import 'package:mocktail/mocktail.dart';

Event _createEvent({required String id, required String city}) {
  return Event(
    id: id,
    name: 'Football Match',
    sport: 'football',
    date: DateTime(2026, 9, 19),
    time: '10:00',
    city: city,
    venue: 'Central Stadium',
    totalSlots: 20,
    availableSlots: 10,
    status: EventStatus.open,
  );
}

EventsData _createEventsData(List<Event> events) {
  return EventsData(events: events, eventReservationStatuses: const {});
}

class _MockLoadEventsWithReservationMarkers extends Mock
    implements UseCase<NoParams, Future<Result<EventsData, AppFailure>>> {}

ProviderContainer _createContainer(
  UseCase<NoParams, Future<Result<EventsData, AppFailure>>> useCase,
) {
  return ProviderContainer(
    overrides: [
      loadEventsWithReservationMarkersUseCaseProvider.overrideWithValue(
        useCase,
      ),
    ],
  );
}

void main() {
  test('exposes the failure when loading events fails', () async {
    const failure = AppFailure(
      failureType: AppFailureType.network,
      message: 'Network unavailable',
    );
    final useCase = _MockLoadEventsWithReservationMarkers();
    when(() => useCase.call(const NoParams())).thenAnswer(
      (_) async => const Failure<EventsData, AppFailure>(failure),
    );
    final container = _createContainer(useCase);
    addTearDown(container.dispose);
    final notifier = container.read(eventsNotifierProvider.notifier);

    await notifier.loadEvents();

    final state = container.read(eventsNotifierProvider);
    expect(state, isA<EventsErrorState>());
    expect((state as EventsErrorState).failure, same(failure));
    verify(() => useCase.call(const NoParams())).called(1);
  });

  test(
    'emits loading while waiting and loaded after the use case completes',
    () async {
      final events = [_createEvent(id: 'event-1', city: 'Lima')];
      final response = Completer<Result<EventsData, AppFailure>>();
      final useCase = _MockLoadEventsWithReservationMarkers();
      when(() => useCase.call(const NoParams())).thenAnswer(
        (_) => response.future,
      );
      final container = _createContainer(useCase);
      addTearDown(container.dispose);
      final observedStates = <Type>[];
      final subscription = container.listen(eventsNotifierProvider, (_, state) {
        observedStates.add(state.runtimeType);
      });
      addTearDown(subscription.close);
      final notifier = container.read(eventsNotifierProvider.notifier);

      final loading = notifier.loadEvents();

      expect(container.read(eventsNotifierProvider), isA<EventsLoadingState>());
      expect(observedStates, contains(EventsLoadingState));

      response.complete(Success(_createEventsData(events)));
      await loading;

      expect(container.read(eventsNotifierProvider), isA<EventsLoadedState>());
      expect(observedStates, [EventsLoadingState, EventsLoadedState]);
      verify(() => useCase.call(const NoParams())).called(1);
    },
  );

  test('recovers from a failed load when loading is retried', () async {
    const failure = AppFailure(
      failureType: AppFailureType.network,
      message: 'Network unavailable',
    );
    final events = [_createEvent(id: 'event-1', city: 'Lima')];
    final results = <Result<EventsData, AppFailure>>[
      const Failure<EventsData, AppFailure>(failure),
      Success(_createEventsData(events)),
    ];
    final useCase = _MockLoadEventsWithReservationMarkers();
    when(() => useCase.call(const NoParams())).thenAnswer(
      (_) async => results.removeAt(0),
    );
    final container = _createContainer(useCase);
    addTearDown(container.dispose);
    final notifier = container.read(eventsNotifierProvider.notifier);

    await notifier.loadEvents();
    expect(container.read(eventsNotifierProvider), isA<EventsErrorState>());

    await notifier.loadEvents();

    final state = container.read(eventsNotifierProvider);
    expect(state, isA<EventsLoadedState>());
    expect((state as EventsLoadedState).events, events);
    verify(() => useCase.call(const NoParams())).called(2);
  });

  test(
    'ignores an older load result when a newer load finishes first',
    () async {
      final olderEvents = [_createEvent(id: 'older-event', city: 'Lima')];
      final newerEvents = [_createEvent(id: 'newer-event', city: 'Cusco')];
      final olderResponse = Completer<Result<EventsData, AppFailure>>();
      final newerResponse = Completer<Result<EventsData, AppFailure>>();
      final responses = [olderResponse, newerResponse];
      final useCase = _MockLoadEventsWithReservationMarkers();
      when(() => useCase.call(const NoParams())).thenAnswer(
        (_) => responses.removeAt(0).future,
      );
      final container = _createContainer(useCase);
      addTearDown(container.dispose);
      final notifier = container.read(eventsNotifierProvider.notifier);

      final olderLoad = notifier.loadEvents();
      final newerLoad = notifier.loadEvents();

      newerResponse.complete(Success(_createEventsData(newerEvents)));
      await newerLoad;
      olderResponse.complete(Success(_createEventsData(olderEvents)));
      await olderLoad;

      final state = container.read(eventsNotifierProvider);
      expect(state, isA<EventsLoadedState>());
      expect((state as EventsLoadedState).events, newerEvents);
      verify(() => useCase.call(const NoParams())).called(2);
    },
  );

  test('applies filters selected before events finish loading', () async {
    final events = [
      _createEvent(id: 'event-1', city: 'Lima'),
      _createEvent(id: 'event-2', city: 'Cusco'),
    ];
    final useCase = _MockLoadEventsWithReservationMarkers();
    when(() => useCase.call(const NoParams())).thenAnswer(
      (_) async => Success(_createEventsData(events)),
    );
    final container = _createContainer(useCase);
    addTearDown(container.dispose);
    final notifier = container.read(eventsNotifierProvider.notifier)
      ..onApplyFilters(EventFilters(selectedCity: 'Lima'));

    await notifier.loadEvents();

    final state = container.read(eventsNotifierProvider);
    expect(state, isA<EventsLoadedState>());
    final loadedState = state as EventsLoadedState;
    expect(loadedState.events, events);
    expect(loadedState.filteredEvents.map((event) => event.id), ['event-1']);
    verify(() => useCase.call(const NoParams())).called(1);
  });

  test('applies new filters after events are loaded', () async {
    final events = [
      _createEvent(id: 'event-1', city: 'Lima'),
      _createEvent(id: 'event-2', city: 'Cusco'),
    ];
    final useCase = _MockLoadEventsWithReservationMarkers();
    when(() => useCase.call(const NoParams())).thenAnswer(
      (_) async => Success(_createEventsData(events)),
    );
    final container = _createContainer(useCase);
    addTearDown(container.dispose);
    final notifier = container.read(eventsNotifierProvider.notifier);

    await notifier.loadEvents();
    notifier.onApplyFilters(EventFilters(selectedCity: 'Cusco'));

    final state = container.read(eventsNotifierProvider);
    expect(state, isA<EventsLoadedState>());
    final loadedState = state as EventsLoadedState;
    expect(loadedState.events, events);
    expect(loadedState.filteredEvents.map((event) => event.id), ['event-2']);
    verify(() => useCase.call(const NoParams())).called(1);
  });
}
