import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/my_reservations/my_reservations_state.dart';

class MyReservationsErrorState extends MyReservationsState {
  const MyReservationsErrorState(this.failure);

  final AppFailure failure;
}
