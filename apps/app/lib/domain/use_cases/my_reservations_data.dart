import 'package:growth_flutter_fase_05_riverpood/domain/entities/event.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/reservation.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/ticket.dart';

/// Contains all data required to render the user's reservations.
final class MyReservationsData {
  /// Creates a complete reservations result for the presentation layer.
  MyReservationsData({
    required List<Reservation> reservations,
    required Map<String, Event> eventsById,
    required Map<String, Ticket> ticketsByReservationId,
  }) : reservations = List.unmodifiable(reservations),
       eventsById = Map.unmodifiable(eventsById),
       ticketsByReservationId = Map.unmodifiable(ticketsByReservationId);

  /// The user's reservations.
  final List<Reservation> reservations;

  /// Events indexed by their identifier.
  final Map<String, Event> eventsById;

  /// Tickets indexed by their reservation identifier.
  final Map<String, Ticket> ticketsByReservationId;
}
