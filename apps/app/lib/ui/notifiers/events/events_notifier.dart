import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growth_flutter_fase_05_riverpood/core/async/async_operation_guard.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/event_filters.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/events/events_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/events/states/events_error_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/events/states/events_initial_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/events/states/events_loaded_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/events/states/events_loading_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/event_providers.dart';

class EventsNotifier extends Notifier<EventsState> {
  final AsyncOperationGuard _operationGuard = AsyncOperationGuard();
  EventFilters _activeFilters = EventFilters();

  @override
  EventsState build() {
    _activeFilters = EventFilters();
    ref.onDispose(_operationGuard.cancel);
    return const EventsInitialState();
  }

  Future<void> loadEvents() async {
    final operationId = _operationGuard.start();
    state = const EventsLoadingState();
    final loadEventsWithReservationMarkersUseCase = ref.read(
      loadEventsWithReservationMarkersUseCaseProvider,
    );
    final result = await loadEventsWithReservationMarkersUseCase();
    if (!_operationGuard.isCurrent(operationId)) return;

    switch (result) {
      case Success(value: final eventsData):
        final filterEventsUseCase = ref.read(filterEventsUseCaseProvider);
        state = EventsLoadedState(
          eventsData.events,
          filteredEvents: filterEventsUseCase(
            events: eventsData.events,
            filters: _activeFilters,
          ),
          eventReservationStatuses: eventsData.eventReservationStatuses,
        );
      case Failure(failure: final appFailure):
        state = EventsErrorState(appFailure);
    }
  }

  /// Applies [filters] to the currently loaded events.
  void onApplyFilters(EventFilters filters) {
    _activeFilters = filters;
    final currentState = state;
    if (currentState is! EventsLoadedState) return;

    final filterEventsUseCase = ref.read(filterEventsUseCaseProvider);
    state = EventsLoadedState(
      currentState.events,
      filteredEvents: filterEventsUseCase(
        events: currentState.events,
        filters: _activeFilters,
      ),
      eventReservationStatuses: currentState.eventReservationStatuses,
    );
  }
}
