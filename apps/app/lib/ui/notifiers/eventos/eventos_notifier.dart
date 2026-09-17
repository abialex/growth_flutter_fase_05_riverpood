import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growth_flutter_fase_05_riverpood/core/async/async_operation_guard.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/eventos/eventos_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/eventos/states/eventos_error_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/eventos/states/eventos_initial_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/eventos/states/eventos_loaded_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/eventos/states/eventos_loading_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/container.dart';

class EventosNotifier extends Notifier<EventosState> {
  final AsyncOperationGuard _operationGuard = AsyncOperationGuard();

  @override
  EventosState build() {
    ref.onDispose(_operationGuard.cancel);
    return const EventosInitialState();
  }

  Future<void> loadEventos() async {
    final operationId = _operationGuard.start();
    state = const EventosLoadingState();
    final loadEventsUseCase = ref.read(loadEventsUseCaseProvider);
    final result = await loadEventsUseCase();
    if (!_operationGuard.isCurrent(operationId)) return;

    switch (result) {
      case Success(value: final eventsData):
        state = EventosLoadedState(
          eventsData.events,
          eventosReservadosIds: eventsData.reservedEventIds,
        );
      case Failure(failure: final appFailure):
        state = EventosErrorState(appFailure);
    }
  }
}
