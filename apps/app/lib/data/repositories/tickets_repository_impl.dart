import '../../core/errors/app_failure.dart';
import '../../core/result/result.dart';
import '../../domain/entities/ticket.dart';
import '../../domain/repositories/tickets_repository.dart';
import '../services/tickets_service.dart';

class TicketsRepositoryImpl implements TicketsRepository {
  TicketsRepositoryImpl(this._ticketsService);

  final TicketsService _ticketsService;

  @override
  Future<Result<List<Ticket>, AppFailure>> getTicketsByReservaId(
    String reservaId,
  ) {
    return _ticketsService.fetchTicketsByReservaId(reservaId);
  }

  @override
  Future<Result<Ticket, AppFailure>> getTicketById(String ticketId) {
    return _ticketsService.fetchTicketById(ticketId);
  }

  @override
  Future<Result<Ticket, AppFailure>> createTicket({
    required String reservaId,
    required String codigo,
  }) {
    return _ticketsService.createTicket(reservaId: reservaId, codigo: codigo);
  }

  @override
  Future<Result<Ticket, AppFailure>> markTicketAsUsed(String ticketId) {
    return _ticketsService.markTicketAsUsed(ticketId);
  }
}
