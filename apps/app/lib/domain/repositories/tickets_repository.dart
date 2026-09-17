import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/ticket.dart';

/// Defines ticket operations required by the domain.
abstract class TicketsRepository {
  /// Gets all tickets associated with the supplied reservation identifiers.
  Future<Result<List<Ticket>, AppFailure>> getTicketsByReservationIds(
    List<String> reservationIds,
  );

  /// Gets a ticket by its [ticketId].
  Future<Result<Ticket, AppFailure>> getTicketById(String ticketId);

  /// Marks a ticket as used.
  Future<Result<Ticket, AppFailure>> markTicketAsUsed(String ticketId);
}
