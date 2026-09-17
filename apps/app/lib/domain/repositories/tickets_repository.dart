import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/ticket.dart';

abstract class TicketsRepository {
  /// Gets all tickets associated with the supplied reservation identifiers.
  Future<Result<List<Ticket>, AppFailure>> getTicketsByReservationIds(
    List<String> reservationIds,
  );

  Future<Result<Ticket, AppFailure>> getTicketById(String ticketId);

  Future<Result<Ticket, AppFailure>> markTicketAsUsed(String ticketId);
}
