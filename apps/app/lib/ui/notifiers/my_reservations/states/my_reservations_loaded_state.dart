import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/reservation_with_details.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/my_reservations/my_reservations_state.dart';

class MyReservationsLoadedState extends MyReservationsState {
  MyReservationsLoadedState({
    required List<ReservationWithDetails> reservations,
    this.isRefreshing = false,
    this.refreshFailure,
  }) : reservations = List.unmodifiable(reservations);

  final List<ReservationWithDetails> reservations;
  final bool isRefreshing;
  final AppFailure? refreshFailure;
}
