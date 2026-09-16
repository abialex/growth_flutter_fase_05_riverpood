import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/ticket.dart';

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
