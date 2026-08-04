import '../../core/errors/app_failure.dart';
import '../../core/result/result.dart';
import '../../domain/entities/reserva.dart';
import '../../domain/repositories/reservas_repository.dart';
import '../services/reservas_service.dart';

class ReservasRepositoryImpl implements ReservasRepository {
  ReservasRepositoryImpl(this._reservasService);

  final ReservasService _reservasService;

  @override
  Future<Result<Reserva, AppFailure>> crearReserva({
    required String eventoId,
    required int cantidadCupos,
  }) {
    return _reservasService.crearReserva(
      eventoId: eventoId,
      cantidadCupos: cantidadCupos,
    );
  }

  @override
  Future<Result<List<Reserva>, AppFailure>> getMisReservas() {
    return _reservasService.fetchMisReservas();
  }
}
