import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growth_flutter_fase_05_riverpood/core/async/async_operation_guard.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/mis_reservas/mis_reservas_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/mis_reservas/states/mis_reservas_error_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/mis_reservas/states/mis_reservas_initial_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/mis_reservas/states/mis_reservas_loaded_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/mis_reservas/states/mis_reservas_loading_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/container.dart';

class MisReservasNotifier extends Notifier<MisReservasState> {
  final AsyncOperationGuard _operationGuard = AsyncOperationGuard();

  @override
  MisReservasState build() {
    ref.onDispose(_operationGuard.cancel);
    return const MisReservasInitialState();
  }

  Future<void> loadMisReservas() async {
    final operationId = _operationGuard.start();
    state = const MisReservasLoadingState();
    final loadMyReservations = ref.read(loadMyReservationsUseCaseProvider);
    final result = await loadMyReservations();
    if (!_operationGuard.isCurrent(operationId)) return;

    state = switch (result) {
      Success(value: final data) => MisReservasLoadedState(
        reservas: data.reservations,
        eventosPorId: data.eventsById,
        ticketsPorReservaId: data.ticketsByReservationId,
      ),
      Failure(failure: final failure) => MisReservasErrorState(failure),
    };
  }
}
