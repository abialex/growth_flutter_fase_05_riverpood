import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growth_flutter_fase_05_riverpood/core/async/async_operation_guard.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservas/confirmar_compra_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservas/states/confirmar_compra_error_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservas/states/confirmar_compra_initial_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservas/states/confirmar_compra_loading_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservas/states/confirmar_compra_success_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/container.dart';

class ConfirmarCompraNotifier extends Notifier<ConfirmarCompraState> {
  final AsyncOperationGuard _operationGuard = AsyncOperationGuard();

  @override
  ConfirmarCompraState build() {
    ref.onDispose(_operationGuard.cancel);
    return const ConfirmarCompraInitialState();
  }

  Future<void> confirmarCompra(String reservaId) async {
    if (state is ConfirmarCompraLoadingState) return;

    final operationId = _operationGuard.start();
    state = ConfirmarCompraLoadingState(reservaId);

    final confirmPurchaseUseCase = ref.read(confirmPurchaseUseCaseProvider);
    final result = await confirmPurchaseUseCase(reservaId);
    if (!_operationGuard.isCurrent(operationId)) return;

    state = switch (result) {
      Success() => ConfirmarCompraSuccessState(reservaId),
      Failure(failure: final appFailure) => ConfirmarCompraErrorState(
        reservaId: reservaId,
        failure: appFailure,
      ),
    };
  }

  void reset() {
    _operationGuard.cancel();
    state = const ConfirmarCompraInitialState();
  }
}
