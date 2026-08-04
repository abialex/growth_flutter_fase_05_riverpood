import '../../../../domain/entities/evento.dart';
import '../eventos_state.dart';

class EventosLoadedState extends EventosState {
  const EventosLoadedState(this.eventos, {this.eventosReservadosIds = const {}});

  final List<Evento> eventos;
  final Set<String> eventosReservadosIds;
}
