import 'package:growth_flutter_fase_05_riverpood/domain/entities/event.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/events/events_state.dart';

class EventsLoadedState extends EventsState {
  const EventsLoadedState(
    this.events, {
    required this.filteredEvents,
    this.reservedEventIds = const {},
  });

  final List<Event> events;
  final List<Event> filteredEvents;
  final Set<String> reservedEventIds;
}
