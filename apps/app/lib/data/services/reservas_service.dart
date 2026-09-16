import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/core/supabase/supabase_crud_service.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/reserva.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/reserva_estado.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReservasService {
  ReservasService(SupabaseClient supabaseClient)
    : _crudService = SupabaseCrudService<Reserva>(
        supabaseClient: supabaseClient,
        tableName: 'reservas',
        fromJson: Reserva.fromJson,
      );

  final SupabaseCrudService<Reserva> _crudService;

  Future<Result<Reserva, AppFailure>> crearReserva({
    required String eventoId,
    required int cantidadCupos,
  }) {
    return _crudService.insertRecord({
      'evento_id': eventoId,
      'cantidad_cupos': cantidadCupos,
      'estado': ReservaEstado.pendiente.name,
    });
  }

  Future<Result<List<Reserva>, AppFailure>> fetchMisReservas() {
    return _crudService.fetchAll(orderByColumn: 'fecha_reserva');
  }

  Future<Result<Reserva, AppFailure>> confirmarReserva(String reservaId) {
    return _crudService.updateRecord(reservaId, {
      'estado': ReservaEstado.confirmada.name,
    });
  }
}
