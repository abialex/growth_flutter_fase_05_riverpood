import 'package:growth_flutter_fase_05_riverpood/domain/entities/evento.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/reserva.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/ticket.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/mis_reservas/mis_reservas_state.dart';

class MisReservasLoadedState extends MisReservasState {
  const MisReservasLoadedState({
    required this.reservas,
    required this.eventosPorId,
    required this.ticketsPorReservaId,
  });

  final List<Reserva> reservas;
  final Map<String, Evento> eventosPorId;
  final Map<String, Ticket> ticketsPorReservaId;
}
