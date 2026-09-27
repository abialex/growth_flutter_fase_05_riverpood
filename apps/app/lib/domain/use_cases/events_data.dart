import 'package:growth_flutter_fase_05_riverpood/domain/entities/event.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/event_reservation_status.dart';

/// Contains events and user relationship markers required by the events screen.
final class EventsData {
  /// Creates the data required by the events screen.
  EventsData({
    required List<Event> events,
    required Map<String, EventReservationStatus> eventReservationStatuses,
  }) : events = List.unmodifiable(events),
       eventReservationStatuses = Map.unmodifiable(eventReservationStatuses);

  /// Events available to the user.
  final List<Event> events;

  /// Relationship status by event identifier for the current user.
  final Map<String, EventReservationStatus> eventReservationStatuses;
}
