import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growth_flutter_fase_05_riverpood/core/async/async_operation_guard.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/evento_detalle/evento_detalle_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/evento_detalle/states/evento_detalle_error_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/evento_detalle/states/evento_detalle_initial_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/evento_detalle/states/evento_detalle_loaded_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/evento_detalle/states/evento_detalle_loading_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/container.dart';

class EventoDetalleNotifier extends Notifier<EventoDetalleState> {
  final AsyncOperationGuard _operationGuard = AsyncOperationGuard();

  @override
  EventoDetalleState build() {
    ref.onDispose(_operationGuard.cancel);
    return const EventoDetalleInitialState();
  }

  Future<void> loadEvento(String eventoId) async {
    final operationId = _operationGuard.start();
    state = const EventoDetalleLoadingState();
    final eventosRepository = ref.read(eventosRepositoryProvider);
    final result = await eventosRepository.getEventoById(eventoId);
    if (!_operationGuard.isCurrent(operationId)) return;

    switch (result) {
      case Success(value: final evento):
        final isReservado = await _isReservado(eventoId);
        if (!_operationGuard.isCurrent(operationId)) return;
        state = EventoDetalleLoadedState(
          evento,
          isReservado: isReservado,
        );
      case Failure(failure: final appFailure):
        state = EventoDetalleErrorState(appFailure);
    }
  }

  Future<bool> _isReservado(String eventoId) async {
    final reservasRepository = ref.read(reservasRepositoryProvider);
    final result = await reservasRepository.getMisReservas();
    return switch (result) {
      Success(value: final reservas) => reservas.any(
        (reserva) => reserva.eventoId == eventoId,
      ),
      Failure() => false,
    };
  }
}
