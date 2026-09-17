import 'package:growth_flutter_fase_05_riverpood/domain/enums/reservation_status.dart';
import 'package:meta/meta.dart';

/// Represents a user's reservation for an event.
@immutable
final class Reservation {
  /// Creates a reservation.
  const Reservation({
    required this.id,
    required this.userId,
    required this.eventId,
    required this.seatCount,
    required this.status,
    required this.reservedAt,
  });

  final String id;
  final String userId;
  final String eventId;
  final int seatCount;
  final ReservationStatus status;
  final DateTime reservedAt;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Reservation &&
            other.id == id &&
            other.userId == userId &&
            other.eventId == eventId &&
            other.seatCount == seatCount &&
            other.status == status &&
            other.reservedAt == reservedAt;
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    eventId,
    seatCount,
    status,
    reservedAt,
  );
}
