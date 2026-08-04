import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/errors/app_failure.dart';
import '../../core/result/result.dart';
import '../../core/supabase/supabase_crud_service.dart';
import '../../domain/entities/ticket.dart';
import '../../domain/enums/ticket_estado.dart';

class TicketsService {
  TicketsService(SupabaseClient supabaseClient)
      : _crudService = SupabaseCrudService<Ticket>(
          supabaseClient: supabaseClient,
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
