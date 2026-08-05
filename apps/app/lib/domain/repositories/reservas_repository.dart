import '../../core/errors/app_failure.dart';
import '../../core/result/result.dart';
import '../entities/reserva.dart';

abstract class ReservasRepository {
  Future<Result<Reserva, AppFailure>> crearReserva({
    required String eventoId,
    required int cantidadCupos,
  });

  Future<Result<List<Reserva>, AppFailure>> getMisReservas();

  Future<Result<Reserva, AppFailure>> confirmarReserva(String reservaId);
}
