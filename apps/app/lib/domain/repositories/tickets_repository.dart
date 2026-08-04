import '../../core/errors/app_failure.dart';
import '../../core/result/result.dart';
import '../entities/ticket.dart';

abstract class TicketsRepository {
  Future<Result<List<Ticket>, AppFailure>> getTicketsByReservaId(
    String reservaId,
  );

  Future<Result<Ticket, AppFailure>> getTicketById(String ticketId);

  Future<Result<Ticket, AppFailure>> createTicket({
    required String reservaId,
    required String codigo,
  });

  Future<Result<Ticket, AppFailure>> markTicketAsUsed(String ticketId);
}
