import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/core/supabase/supabase_crud_service.dart';
import 'package:growth_flutter_fase_05_riverpood/core/supabase/supabase_logger.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/ticket.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/ticket_estado.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TicketsService {
  TicketsService(SupabaseClient supabaseClient, SupabaseLogger logger)
    : _crudService = SupabaseCrudService<Ticket>(
        supabaseClient: supabaseClient,
        logger: logger,
        tableName: 'tickets',
        fromJson: Ticket.fromJson,
      );

  final SupabaseCrudService<Ticket> _crudService;

  Future<Result<List<Ticket>, AppFailure>> fetchTicketsByReservaId(
    String reservaId,
  ) {
    return _crudService.fetchWhere('reserva_id', reservaId);
  }

  Future<Result<Ticket, AppFailure>> fetchTicketById(String ticketId) {
    return _crudService.fetchById(ticketId);
  }

  Future<Result<Ticket, AppFailure>> createTicket({
    required String reservaId,
    required String codigo,
  }) {
    return _crudService.insertRecord({
      'reserva_id': reservaId,
      'codigo': codigo,
      'estado': TicketEstado.valido.name,
    });
  }

  Future<Result<Ticket, AppFailure>> markTicketAsUsed(String ticketId) {
    return _crudService.updateRecord(ticketId, {
      'estado': TicketEstado.usado.name,
    });
  }
}
