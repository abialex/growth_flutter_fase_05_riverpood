import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservas/reservar_state.dart';

class ReservarErrorState extends ReservarState {
  const ReservarErrorState(this.failure);

  final AppFailure failure;
}
