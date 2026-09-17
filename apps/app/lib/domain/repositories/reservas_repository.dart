import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/reserva.dart';

abstract class ReservasRepository {
  Future<Result<Reserva, AppFailure>> crearReserva({
    required String eventoId,
    required int cantidadCupos,
  });

  Future<Result<List<Reserva>, AppFailure>> getMisReservas();
}
