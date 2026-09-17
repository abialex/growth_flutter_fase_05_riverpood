import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/data/services/reservas_service.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/reserva.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/reservas_repository.dart';

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
