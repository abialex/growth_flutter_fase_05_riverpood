import 'package:growth_flutter_fase_05_riverpood/domain/entities/evento.dart';

/// Contains an event and its reservation status for the current user.
final class EventDetailData {
  /// Creates event detail data.
  const EventDetailData({required this.event, required this.isReserved});

  /// The requested event.
  final Evento event;

  /// Whether the current user has already reserved the event.
  final bool isReserved;
}
