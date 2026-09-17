import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservations/create_reservation_state.dart';

class CreateReservationErrorState extends CreateReservationState {
  const CreateReservationErrorState(this.failure);

  final AppFailure failure;
}
