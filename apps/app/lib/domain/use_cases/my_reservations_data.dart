import 'package:growth_flutter_fase_05_riverpood/domain/entities/evento.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/reserva.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/ticket.dart';

/// Contains all data required to render the user's reservations.
final class MyReservationsData {
  /// Creates a complete reservations result for the presentation layer.
  MyReservationsData({
    required List<Reserva> reservations,
    required Map<String, Evento> eventsById,
    required Map<String, Ticket> ticketsByReservationId,
  }) : reservations = List.unmodifiable(reservations),
       eventsById = Map.unmodifiable(eventsById),
       ticketsByReservationId = Map.unmodifiable(ticketsByReservationId);

  /// The user's reservations.
  final List<Reserva> reservations;

  /// Events indexed by their identifier.
  final Map<String, Evento> eventsById;

  /// Tickets indexed by their reservation identifier.
  final Map<String, Ticket> ticketsByReservationId;
}
