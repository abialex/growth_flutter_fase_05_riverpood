import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/reserva.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/reservas_repository.dart';

/// Creates a reservation for an event.
final class CreateReservationUseCase {
  /// Creates a use case with the reservations repository.
  const CreateReservationUseCase({
    required ReservasRepository reservasRepository,
  }) : _reservasRepository = reservasRepository;

  final ReservasRepository _reservasRepository;

  /// Creates a reservation for [eventoId].
  Future<Result<Reserva, AppFailure>> call({
    required String eventoId,
    required int cantidadCupos,
  }) {
    return _reservasRepository.crearReserva(
      eventoId: eventoId,
      cantidadCupos: cantidadCupos,
    );
  }
}
