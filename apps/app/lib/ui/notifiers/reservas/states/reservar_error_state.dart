import '../../../../core/errors/app_failure.dart';
import '../reservar_state.dart';

class ReservarErrorState extends ReservarState {
  const ReservarErrorState(this.failure);

  final AppFailure failure;
}
