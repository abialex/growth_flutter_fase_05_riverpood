import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/evento_detalle/evento_detalle_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/evento_detalle/states/evento_detalle_error_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/evento_detalle/states/evento_detalle_initial_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/evento_detalle/states/evento_detalle_loaded_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/evento_detalle/states/evento_detalle_loading_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/eventos_providers.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/reservas_providers.dart';

class EventoDetalleNotifier extends Notifier<EventoDetalleState> {
  @override
  EventoDetalleState build() => const EventoDetalleInitialState();

  Future<void> loadEvento(String eventoId) async {
    state = const EventoDetalleLoadingState();
    final eventosRepository = ref.read(eventosRepositoryProvider);
    final result = await eventosRepository.getEventoById(eventoId);
    state = switch (result) {
      Success(value: final evento) => EventoDetalleLoadedState(
        evento,
        isReservado: await _isReservado(eventoId),
      ),
      Failure(failure: final appFailure) => EventoDetalleErrorState(appFailure),
    };
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
