import '../../../../domain/entities/evento.dart';
import '../evento_detalle_state.dart';

class EventoDetalleLoadedState extends EventoDetalleState {
  const EventoDetalleLoadedState(this.evento, {this.isReservado = false});

  final Evento evento;
  final bool isReservado;
}
