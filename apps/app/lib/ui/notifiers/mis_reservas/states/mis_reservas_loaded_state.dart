import '../../../../domain/entities/evento.dart';
import '../../../../domain/entities/reserva.dart';
import '../mis_reservas_state.dart';

class MisReservasLoadedState extends MisReservasState {
  const MisReservasLoadedState({required this.reservas, required this.eventosPorId});

  final List<Reserva> reservas;
  final Map<String, Evento> eventosPorId;
}
