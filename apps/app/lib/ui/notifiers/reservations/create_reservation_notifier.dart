import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growth_flutter_fase_05_riverpood/core/async/async_operation_guard.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservations/create_reservation_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservations/states/create_reservation_error_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservations/states/create_reservation_initial_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservations/states/create_reservation_loading_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservations/states/create_reservation_success_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/container.dart';

class CreateReservationNotifier extends Notifier<CreateReservationState> {
  final AsyncOperationGuard _operationGuard = AsyncOperationGuard();

  @override
  CreateReservationState build() {
    ref.onDispose(_operationGuard.cancel);
    return const CreateReservationInitialState();
  }

  Future<void> onCreateReservation({
    required String eventId,
    required int seatCount,
  }) async {
    if (state is CreateReservationLoadingState) return;

    final operationId = _operationGuard.start();
    state = const CreateReservationLoadingState();
    final createReservationUseCase = ref.read(createReservationUseCaseProvider);
    final result = await createReservationUseCase(
      eventId: eventId,
      seatCount: seatCount,
    );
    if (!_operationGuard.isCurrent(operationId)) return;

    state = switch (result) {
      Success() => const CreateReservationSuccessState(),
      Failure(failure: final appFailure) => CreateReservationErrorState(
        appFailure,
      ),
    };
  }

  void reset() {
    _operationGuard.cancel();
    state = const CreateReservationInitialState();
  }
}
