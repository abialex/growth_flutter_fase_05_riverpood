import 'package:growth_flutter_fase_05_riverpood/domain/entities/event.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/reservation.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/ticket.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/my_reservations/my_reservations_state.dart';

class MyReservationsLoadedState extends MyReservationsState {
  const MyReservationsLoadedState({
    required this.reservations,
    required this.eventsById,
    required this.ticketsByReservationId,
  });

  final List<Reservation> reservations;
  final Map<String, Event> eventsById;
  final Map<String, Ticket> ticketsByReservationId;
}
