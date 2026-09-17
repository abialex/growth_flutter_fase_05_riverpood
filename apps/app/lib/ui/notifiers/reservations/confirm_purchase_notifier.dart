import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growth_flutter_fase_05_riverpood/core/async/async_operation_guard.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservations/confirm_purchase_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservations/states/confirm_purchase_error_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservations/states/confirm_purchase_initial_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservations/states/confirm_purchase_loading_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservations/states/confirm_purchase_success_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/container.dart';

class ConfirmPurchaseNotifier extends Notifier<ConfirmPurchaseState> {
  final AsyncOperationGuard _operationGuard = AsyncOperationGuard();

  @override
  ConfirmPurchaseState build() {
    ref.onDispose(_operationGuard.cancel);
    return const ConfirmPurchaseInitialState();
  }

  Future<void> onConfirmPurchase(String reservationId) async {
    if (state is ConfirmPurchaseLoadingState) return;

    final operationId = _operationGuard.start();
    state = ConfirmPurchaseLoadingState(reservationId);

    final confirmPurchaseUseCase = ref.read(confirmPurchaseUseCaseProvider);
    final result = await confirmPurchaseUseCase(reservationId);
    if (!_operationGuard.isCurrent(operationId)) return;

    state = switch (result) {
      Success() => ConfirmPurchaseSuccessState(reservationId),
      Failure(failure: final appFailure) => ConfirmPurchaseErrorState(
        reservationId: reservationId,
        failure: appFailure,
      ),
    };
  }

  void reset() {
    _operationGuard.cancel();
    state = const ConfirmPurchaseInitialState();
  }
}
