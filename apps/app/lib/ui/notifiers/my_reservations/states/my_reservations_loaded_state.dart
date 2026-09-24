import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/my_reservations_data.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/my_reservations/my_reservations_state.dart';

class MyReservationsLoadedState extends MyReservationsState {
  const MyReservationsLoadedState({
    required this.data,
    this.isRefreshing = false,
    this.refreshFailure,
  });

  final MyReservationsData data;
  final bool isRefreshing;
  final AppFailure? refreshFailure;
}
