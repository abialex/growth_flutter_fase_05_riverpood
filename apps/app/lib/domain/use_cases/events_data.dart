import 'package:growth_flutter_fase_05_riverpood/domain/entities/evento.dart';

/// Contains the events and reservation markers required by the events screen.
final class EventsData {
  /// Creates the data required by the events screen.
  EventsData({
    required List<Evento> events,
    required Set<String> reservedEventIds,
  }) : events = List.unmodifiable(events),
       reservedEventIds = Set.unmodifiable(reservedEventIds);

  /// Events available to the user.
  final List<Evento> events;

  /// Identifiers of events already reserved by the user.
  final Set<String> reservedEventIds;
}
