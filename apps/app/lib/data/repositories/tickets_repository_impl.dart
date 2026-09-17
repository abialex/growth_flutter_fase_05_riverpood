import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/data/services/tickets_service.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/ticket.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/tickets_repository.dart';

class TicketsRepositoryImpl implements TicketsRepository {
  TicketsRepositoryImpl(this._ticketsService);

  final TicketsService _ticketsService;

  @override
  Future<Result<List<Ticket>, AppFailure>> getTicketsByReservaIds(
    List<String> reservaIds,
  ) {
    return _ticketsService.fetchTicketsByReservaIds(reservaIds);
  }

  @override
  Future<Result<Ticket, AppFailure>> getTicketById(String ticketId) {
    return _ticketsService.fetchTicketById(ticketId);
  }

  @override
  Future<Result<Ticket, AppFailure>> markTicketAsUsed(String ticketId) {
    return _ticketsService.markTicketAsUsed(ticketId);
  }
}
