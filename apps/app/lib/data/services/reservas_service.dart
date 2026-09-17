import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/errors/failure_mapper.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/core/supabase/supabase_crud_service.dart';
import 'package:growth_flutter_fase_05_riverpood/core/supabase/supabase_logger.dart';
import 'package:growth_flutter_fase_05_riverpood/data/models/reservation_model.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/reserva.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/reserva_estado.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReservasService {
  ReservasService(
    SupabaseClient supabaseClient,
    SupabaseLogger logger,
    FailureMapper failureMapper,
  ) : _crudService = SupabaseCrudService<ReservationModel>(
        supabaseClient: supabaseClient,
        logger: logger,
        failureMapper: failureMapper,
        tableName: 'reservas',
        fromJson: ReservationModel.fromJson,
      );

  final SupabaseCrudService<ReservationModel> _crudService;

  Future<Result<Reserva, AppFailure>> crearReserva({
    required String eventoId,
    required int cantidadCupos,
  }) async {
    final result = await _crudService.callRpc(
      functionName: 'crear_reserva',
      parameters: {
        'p_evento_id': eventoId,
        'p_cantidad_cupos': cantidadCupos,
      },
    );
    return switch (result) {
      Success(value: final model) => Success(model.toEntity()),
      Failure(failure: final appFailure) => Failure(appFailure),
    };
  }

  Future<Result<List<Reserva>, AppFailure>> fetchMisReservas() async {
    final result = await _crudService.fetchAll(orderByColumn: 'fecha_reserva');
    return switch (result) {
      Success(value: final models) => Success(
        models.map((model) => model.toEntity()).toList(),
      ),
      Failure(failure: final appFailure) => Failure(appFailure),
    };
  }

  Future<Result<Reserva, AppFailure>> confirmarReserva(String reservaId) async {
    final result = await _crudService.updateRecord(reservaId, {
      'estado': ReservaEstado.confirmada.name,
    });
    return switch (result) {
      Success(value: final model) => Success(model.toEntity()),
      Failure(failure: final appFailure) => Failure(appFailure),
    };
  }
}
