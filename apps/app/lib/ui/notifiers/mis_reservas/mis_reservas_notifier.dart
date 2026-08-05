import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/result/result.dart';
import '../../../domain/entities/evento.dart';
import '../../../domain/entities/reserva.dart';
import '../../../domain/entities/ticket.dart';
import '../../../domain/enums/reserva_estado.dart';
import '../../providers/eventos_providers.dart';
import '../../providers/reservas_providers.dart';
import '../../providers/tickets_providers.dart';
import '../eventos/states/eventos_loaded_state.dart';
import 'mis_reservas_state.dart';
import 'states/mis_reservas_error_state.dart';
import 'states/mis_reservas_initial_state.dart';
import 'states/mis_reservas_loaded_state.dart';
import 'states/mis_reservas_loading_state.dart';

class MisReservasNotifier extends Notifier<MisReservasState> {
  @override
  MisReservasState build() {
    Future.microtask(loadMisReservas);
    return const MisReservasInitialState();
  }

  Future<void> loadMisReservas() async {
    state = const MisReservasLoadingState();
    final reservasRepository = ref.read(reservasRepositoryProvider);
    final result = await reservasRepository.getMisReservas();
    switch (result) {
      case Success(value: final reservas):
        final eventosPorId = await _fetchEventosPorId();
        final ticketsPorReservaId = await _fetchTicketsPorReservaId(reservas);
        state = MisReservasLoadedState(
          reservas: reservas,
          eventosPorId: eventosPorId,
          ticketsPorReservaId: ticketsPorReservaId,
        );
      case Failure(failure: final appFailure):
        state = MisReservasErrorState(appFailure);
    }
  }

  Future<Map<String, Ticket>> _fetchTicketsPorReservaId(List<Reserva> reservas) async {
    final ticketsRepository = ref.read(ticketsRepositoryProvider);
    final reservasConfirmadas =
        reservas.where((reserva) => reserva.estado == ReservaEstado.confirmada);

    final ticketsPorReservaId = <String, Ticket>{};
    for (final reserva in reservasConfirmadas) {
      final result = await ticketsRepository.getTicketsByReservaId(reserva.id);
      if (result case Success(value: final tickets) when tickets.isNotEmpty) {
        ticketsPorReservaId[reserva.id] = tickets.first;
      }
    }
    return ticketsPorReservaId;
  }

  Future<Map<String, Evento>> _fetchEventosPorId() async {
    final eventosState = ref.read(eventosNotifierProvider);
    List<Evento> eventos;
    if (eventosState is EventosLoadedState) {
      eventos = eventosState.eventos;
    } else {
      final eventosRepository = ref.read(eventosRepositoryProvider);
      final result = await eventosRepository.getEventos();
      eventos = switch (result) {
        Success(value: final eventosCargados) => eventosCargados,
        Failure() => const [],
      };
    }
    return {for (final evento in eventos) evento.id: evento};
  }
}
