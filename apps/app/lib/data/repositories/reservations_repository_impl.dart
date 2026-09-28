import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/data/services/reservations_service.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/reservation.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/reservation_with_details.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/reservations_repository.dart';

/// Implements [ReservationsRepository] with the reservation data service.
class ReservationsRepositoryImpl implements ReservationsRepository {
  /// Creates a reservation repository.
  ReservationsRepositoryImpl(this._reservationsService);

  final ReservationsService _reservationsService;

  @override
  Future<Result<Reservation, AppFailure>> createReservation({
    required String eventId,
    required int seatCount,
  }) {
    return _reservationsService.createReservation(
      eventId: eventId,
      seatCount: seatCount,
    );
  }

  @override
  Future<Result<List<Reservation>, AppFailure>> getMyReservations() {
    return _reservationsService.fetchMyReservations();
  }

  @override
  Future<Result<List<ReservationWithDetails>, AppFailure>>
  getMyReservationsWithDetails() {
    return _reservationsService.fetchMyReservationsWithDetails();
  }
}
