import 'package:growth_flutter_fase_05_riverpood/domain/entities/evento.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/eventos/eventos_state.dart';

class EventosLoadedState extends EventosState {
  const EventosLoadedState(
    this.eventos, {
    this.eventosReservadosIds = const {},
  });

  final List<Evento> eventos;
  final Set<String> eventosReservadosIds;
}
