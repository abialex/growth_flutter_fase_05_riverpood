import '../../../../core/errors/app_failure.dart';
import '../mis_reservas_state.dart';

class MisReservasErrorState extends MisReservasState {
  const MisReservasErrorState(this.failure);

  final AppFailure failure;
}
