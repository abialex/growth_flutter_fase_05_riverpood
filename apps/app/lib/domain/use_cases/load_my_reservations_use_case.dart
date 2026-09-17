import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/event.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/reservation.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/ticket.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/reservation_status.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/events_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/reservations_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/tickets_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/my_reservations_data.dart';

/// Loads the complete data required by the user's reservations screen.
final class LoadMyReservationsUseCase {
  /// Creates a use case with the repositories required by the flow.
  const LoadMyReservationsUseCase({
    required ReservationsRepository reservationsRepository,
    required EventsRepository eventsRepository,
    required TicketsRepository ticketsRepository,
  }) : _reservationsRepository = reservationsRepository,
       _eventsRepository = eventsRepository,
       _ticketsRepository = ticketsRepository;

  final ReservationsRepository _reservationsRepository;
  final EventsRepository _eventsRepository;
  final TicketsRepository _ticketsRepository;

  /// Loads reservations and their related events and tickets.
  Future<Result<MyReservationsData, AppFailure>> call() async {
    final reservationsResult = await _reservationsRepository
        .getMyReservations();
    return switch (reservationsResult) {
      Failure(failure: final failure) => Failure(failure),
      Success(value: final reservations) => _loadRelatedData(reservations),
    };
  }

  Future<Result<MyReservationsData, AppFailure>> _loadRelatedData(
    List<Reservation> reservations,
  ) async {
    final eventsResult = await _eventsRepository.getEvents();
    return switch (eventsResult) {
      Failure(failure: final failure) => Failure(failure),
      Success(value: final events) => _loadTickets(reservations, events),
    };
  }

  Future<Result<MyReservationsData, AppFailure>> _loadTickets(
    List<Reservation> reservations,
    List<Event> events,
  ) async {
    final reservationIds = reservations
        .where(
          (reservation) => reservation.status == ReservationStatus.confirmed,
        )
        .map((reservation) => reservation.id)
        .toList();
    final ticketsResult = await _ticketsRepository.getTicketsByReservationIds(
      reservationIds,
    );

    return switch (ticketsResult) {
      Failure(failure: final failure) => Failure(failure),
      Success(value: final tickets) => Success(
        MyReservationsData(
          reservations: reservations,
          eventsById: {for (final event in events) event.id: event},
          ticketsByReservationId: _mapTicketsByReservationId(tickets),
        ),
      ),
    };
  }

  Map<String, Ticket> _mapTicketsByReservationId(List<Ticket> tickets) {
    final ticketsByReservationId = <String, Ticket>{};
    for (final ticket in tickets) {
      ticketsByReservationId.putIfAbsent(ticket.reservationId, () => ticket);
    }
    return ticketsByReservationId;
  }
}
