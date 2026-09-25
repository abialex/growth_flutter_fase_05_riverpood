import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growth_flutter_fase_05_riverpood/core/async/async_operation_guard.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/events/events_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/events/states/events_error_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/events/states/events_initial_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/events/states/events_loaded_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/events/states/events_loading_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/event_providers.dart';

class EventsNotifier extends Notifier<EventsState> {
  final AsyncOperationGuard _operationGuard = AsyncOperationGuard();

  @override
  EventsState build() {
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
        state = EventsLoadedState(
          eventsData.events,
          reservedEventIds: eventsData.reservedEventIds,
        );
      case Failure(failure: final appFailure):
        state = EventsErrorState(appFailure);
    }
  }
}
