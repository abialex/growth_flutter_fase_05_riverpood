import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/reservation_with_details.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/reservations_repository.dart';

/// Loads the user's reservations with their related event and ticket details.
final class LoadMyReservationsUseCase {
  /// Creates a use case with the reservation repository.
  const LoadMyReservationsUseCase({
    required ReservationsRepository reservationsRepository,
  }) : _reservationsRepository = reservationsRepository;

  final ReservationsRepository _reservationsRepository;

  /// Loads reservations and their related events and tickets.
  Future<Result<List<ReservationWithDetails>, AppFailure>> call() {
    return _reservationsRepository.getMyReservationsWithDetails();
  }
}
