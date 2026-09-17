import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/reservation.dart';

abstract class ReservationsRepository {
  Future<Result<Reservation, AppFailure>> createReservation({
    required String eventId,
    required int seatCount,
  });

  Future<Result<List<Reservation>, AppFailure>> getMyReservations();
}
