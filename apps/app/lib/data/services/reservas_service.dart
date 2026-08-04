import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/errors/app_failure.dart';
import '../../core/result/result.dart';
import '../../core/supabase/supabase_crud_service.dart';
import '../../domain/entities/reserva.dart';
import '../../domain/enums/reserva_estado.dart';

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
}
