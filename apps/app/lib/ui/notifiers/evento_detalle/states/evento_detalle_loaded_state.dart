import 'package:growth_flutter_fase_05_riverpood/domain/entities/evento.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/evento_detalle/evento_detalle_state.dart';

class EventoDetalleLoadedState extends EventoDetalleState {
  const EventoDetalleLoadedState(this.evento, {this.isReservado = false});

  final Evento evento;
  final bool isReservado;
}
