import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growth_flutter_fase_05_riverpood/core/async/async_operation_guard.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/event_detail/event_detail_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/event_detail/states/event_detail_error_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/event_detail/states/event_detail_initial_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/event_detail/states/event_detail_loaded_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/event_detail/states/event_detail_loading_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/container.dart';

class EventDetailNotifier extends Notifier<EventDetailState> {
  final AsyncOperationGuard _operationGuard = AsyncOperationGuard();

  @override
  EventDetailState build() {
    ref.onDispose(_operationGuard.cancel);
    return const EventDetailInitialState();
  }

  Future<void> loadEvent(String eventId) async {
    final operationId = _operationGuard.start();
    state = const EventDetailLoadingState();
    final loadEventDetailUseCase = ref.read(loadEventDetailUseCaseProvider);
    final result = await loadEventDetailUseCase(eventId);
    if (!_operationGuard.isCurrent(operationId)) return;

    switch (result) {
      case Success(value: final data):
        state = EventDetailLoadedState(
          data.event,
          isReserved: data.isReserved,
        );
      case Failure(failure: final appFailure):
        state = EventDetailErrorState(appFailure);
    }
  }
}
