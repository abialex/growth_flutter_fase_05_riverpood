import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/reservation.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/reservations_repository.dart';

/// Creates a reservation for an event.
final class CreateReservationUseCase {
  /// Creates a use case with the reservations repository.
  const CreateReservationUseCase({
    required ReservationsRepository reservationsRepository,
  }) : _reservationsRepository = reservationsRepository;

  final ReservationsRepository _reservationsRepository;

  /// Creates a reservation for [eventId].
  Future<Result<Reservation, AppFailure>> call({
    required String eventId,
    required int seatCount,
  }) {
    return _reservationsRepository.createReservation(
      eventId: eventId,
      seatCount: seatCount,
    );
  }
}
