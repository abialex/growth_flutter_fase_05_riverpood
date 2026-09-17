import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growth_flutter_fase_05_riverpood/core/async/async_operation_guard.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservas/reservar_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservas/states/reservar_error_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservas/states/reservar_initial_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservas/states/reservar_loading_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservas/states/reservar_success_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/container.dart';

class ReservarNotifier extends Notifier<ReservarState> {
  final AsyncOperationGuard _operationGuard = AsyncOperationGuard();

  @override
  ReservarState build() {
    ref.onDispose(_operationGuard.cancel);
    return const ReservarInitialState();
  }

  Future<void> reservar({
    required String eventoId,
    required int cantidadCupos,
  }) async {
    if (state is ReservarLoadingState) return;

    final operationId = _operationGuard.start();
    state = const ReservarLoadingState();
    final createReservationUseCase = ref.read(createReservationUseCaseProvider);
    final result = await createReservationUseCase(
      eventoId: eventoId,
      cantidadCupos: cantidadCupos,
    );
    if (!_operationGuard.isCurrent(operationId)) return;

    state = switch (result) {
      Success() => const ReservarSuccessState(),
      Failure(failure: final appFailure) => ReservarErrorState(appFailure),
    };
  }

  void reset() {
    _operationGuard.cancel();
    state = const ReservarInitialState();
  }
}
