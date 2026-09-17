import 'package:growth_flutter_fase_05_riverpood/domain/enums/event_status.dart';
import 'package:meta/meta.dart';

/// Represents an event available for reservation.
@immutable
final class Event {
  /// Creates an event.
  const Event({
    required this.id,
    required this.name,
    required this.sport,
    required this.date,
    required this.time,
    required this.city,
    required this.venue,
    required this.totalSlots,
    required this.availableSlots,
    required this.status,
    this.description,
  });

  final String id;
  final String name;
  final String sport;
  final DateTime date;
  final String time;
  final String city;
  final String venue;
  final int totalSlots;
  final int availableSlots;
  final EventStatus status;
  final String? description;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Event &&
            other.id == id &&
            other.name == name &&
            other.sport == sport &&
            other.date == date &&
            other.time == time &&
            other.city == city &&
            other.venue == venue &&
            other.totalSlots == totalSlots &&
            other.availableSlots == availableSlots &&
            other.status == status &&
            other.description == description;
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    sport,
    date,
    time,
    city,
    venue,
    totalSlots,
    availableSlots,
    status,
    description,
  );
}
