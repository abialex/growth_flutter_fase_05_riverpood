import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/errors/failure_mapper.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/core/supabase/supabase_crud_service.dart';
import 'package:growth_flutter_fase_05_riverpood/core/supabase/supabase_logger.dart';
import 'package:growth_flutter_fase_05_riverpood/data/models/ticket_model.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/ticket.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Executes atomic purchase operations through Supabase RPC functions.
final class PurchaseService {
  /// Creates a purchase service with the Supabase dependencies it needs.
  PurchaseService(
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

  /// Confirms [reservationId] and creates its ticket in one transaction.
  Future<Result<Ticket, AppFailure>> confirmPurchase(
    String reservationId,
  ) async {
    final result = await _crudService.callRpc(
      functionName: 'confirmar_compra',
      parameters: {'p_reserva_id': reservationId},
    );
    return switch (result) {
      Success(value: final model) => Success(model.toEntity()),
      Failure(failure: final appFailure) => Failure(appFailure),
    };
  }
}
