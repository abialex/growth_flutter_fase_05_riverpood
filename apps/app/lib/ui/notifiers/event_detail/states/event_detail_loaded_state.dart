import 'package:growth_flutter_fase_05_riverpood/domain/entities/event.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/event_detail/event_detail_state.dart';

class EventDetailLoadedState extends EventDetailState {
  const EventDetailLoadedState(this.event, {this.isReserved = false});

  final Event event;
  final bool isReserved;
}
