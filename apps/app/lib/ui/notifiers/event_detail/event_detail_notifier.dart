import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growth_flutter_fase_05_riverpood/core/async/async_operation_guard.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/event_detail/event_detail_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/event_detail/states/event_detail_error_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/event_detail/states/event_detail_loaded_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/event_detail/states/event_detail_loading_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/container.dart';

class EventDetailNotifier extends Notifier<EventDetailState> {
  EventDetailNotifier(this._eventId);

  final String _eventId;
  final AsyncOperationGuard _operationGuard = AsyncOperationGuard();

  @override
  EventDetailState build() {
    ref.onDispose(_operationGuard.cancel);
    final operationId = _operationGuard.start();
    unawaited(_loadEvent(operationId));
    return const EventDetailLoadingState();
  }

  Future<void> onRetry() {
    final operationId = _operationGuard.start();
    state = const EventDetailLoadingState();
    return _loadEvent(operationId);
  }

  Future<void> _loadEvent(int operationId) async {
    final loadEventDetailUseCase = ref.read(loadEventDetailUseCaseProvider);
    final result = await loadEventDetailUseCase(_eventId);
    if (!_operationGuard.isCurrent(operationId)) return;

    switch (result) {
      case Success(value: final data):
        final evaluateReservationEligibility = ref.read(
          evaluateReservationEligibilityUseCaseProvider,
        );
        state = EventDetailLoadedState(
          event: data.event,
          reservationEligibility: evaluateReservationEligibility(
            event: data.event,
            isReserved: data.isReserved,
            seatCount: 1,
          ),
        );
      case Failure(failure: final appFailure):
        state = EventDetailErrorState(appFailure);
    }
  }
}
