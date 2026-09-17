import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/errors/failure_mapper.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/core/supabase/supabase_crud_service.dart';
import 'package:growth_flutter_fase_05_riverpood/core/supabase/supabase_logger.dart';
import 'package:growth_flutter_fase_05_riverpood/data/models/ticket_model.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/ticket.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/ticket_estado.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TicketsService {
  TicketsService(
    SupabaseClient supabaseClient,
    SupabaseLogger logger,
    FailureMapper failureMapper,
  ) : _crudService = SupabaseCrudService<TicketModel>(
        supabaseClient: supabaseClient,
        logger: logger,
        failureMapper: failureMapper,
        tableName: 'tickets',
        fromJson: TicketModel.fromJson,
      );

  final SupabaseCrudService<TicketModel> _crudService;

  /// Fetches all tickets linked to [reservaIds] in one request.
  Future<Result<List<Ticket>, AppFailure>> fetchTicketsByReservaIds(
    List<String> reservaIds,
  ) async {
    final result = await _crudService.fetchWhereIn('reserva_id', reservaIds);
    return switch (result) {
      Success(value: final models) => Success(
        models.map((model) => model.toEntity()).toList(),
      ),
      Failure(failure: final appFailure) => Failure(appFailure),
    };
  }

  Future<Result<Ticket, AppFailure>> fetchTicketById(String ticketId) async {
    final result = await _crudService.fetchById(ticketId);
    return switch (result) {
      Success(value: final model) => Success(model.toEntity()),
      Failure(failure: final appFailure) => Failure(appFailure),
    };
  }

  Future<Result<Ticket, AppFailure>> createTicket({
    required String reservaId,
    required String codigo,
  }) async {
    final result = await _crudService.insertRecord({
      'reserva_id': reservaId,
      'codigo': codigo,
      'estado': TicketEstado.valido.name,
    });
    return switch (result) {
      Success(value: final model) => Success(model.toEntity()),
      Failure(failure: final appFailure) => Failure(appFailure),
    };
  }

  Future<Result<Ticket, AppFailure>> markTicketAsUsed(String ticketId) async {
    final result = await _crudService.updateRecord(ticketId, {
      'estado': TicketEstado.usado.name,
    });
    return switch (result) {
      Success(value: final model) => Success(model.toEntity()),
      Failure(failure: final appFailure) => Failure(appFailure),
    };
  }
}
