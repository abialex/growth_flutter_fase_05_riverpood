import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/reservation.dart';

/// Defines reservation operations required by the domain.
abstract class ReservationsRepository {
  /// Creates a reservation for an event.
  Future<Result<Reservation, AppFailure>> createReservation({
    required String eventId,
    required int seatCount,
  });

  /// Gets reservations belonging to the current user.
  Future<Result<List<Reservation>, AppFailure>> getMyReservations();
}
