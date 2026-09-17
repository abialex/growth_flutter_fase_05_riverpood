import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/evento.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/reserva.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/ticket.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/reserva_estado.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/eventos_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/reservas_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/tickets_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/my_reservations_data.dart';

/// Loads the complete data required by the user's reservations screen.
final class LoadMyReservationsUseCase {
  /// Creates a use case with the repositories required by the flow.
  const LoadMyReservationsUseCase({
    required ReservasRepository reservasRepository,
    required EventosRepository eventosRepository,
    required TicketsRepository ticketsRepository,
  }) : _reservasRepository = reservasRepository,
       _eventosRepository = eventosRepository,
       _ticketsRepository = ticketsRepository;

  final ReservasRepository _reservasRepository;
  final EventosRepository _eventosRepository;
  final TicketsRepository _ticketsRepository;

  /// Loads reservations and their related events and tickets.
  Future<Result<MyReservationsData, AppFailure>> call() async {
    final reservationsResult = await _reservasRepository.getMisReservas();
    return switch (reservationsResult) {
      Failure(failure: final failure) => Failure(failure),
      Success(value: final reservations) => _loadRelatedData(reservations),
    };
  }

  Future<Result<MyReservationsData, AppFailure>> _loadRelatedData(
    List<Reserva> reservations,
  ) async {
    final eventsResult = await _eventosRepository.getEventos();
    return switch (eventsResult) {
      Failure(failure: final failure) => Failure(failure),
      Success(value: final events) => _loadTickets(reservations, events),
    };
  }

  Future<Result<MyReservationsData, AppFailure>> _loadTickets(
    List<Reserva> reservations,
    List<Evento> events,
  ) async {
    final reservationIds = reservations
        .where(
          (reservation) => reservation.estado == ReservaEstado.confirmada,
        )
        .map((reservation) => reservation.id)
        .toList();
    final ticketsResult = await _ticketsRepository.getTicketsByReservaIds(
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
      ticketsByReservationId.putIfAbsent(ticket.reservaId, () => ticket);
    }
    return ticketsByReservationId;
  }
}
