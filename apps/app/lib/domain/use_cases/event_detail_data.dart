import 'package:growth_flutter_fase_05_riverpood/domain/entities/event.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/reservation_with_details.dart';

/// Contains an event and its reservation details for the current user.
final class EventDetailData {
  /// Creates event detail data.
  const EventDetailData({required this.event, this.reservationDetails});

  /// The requested event.
  final Event event;

  /// The current user's reservation for the event, when one exists.
  final ReservationWithDetails? reservationDetails;
}
