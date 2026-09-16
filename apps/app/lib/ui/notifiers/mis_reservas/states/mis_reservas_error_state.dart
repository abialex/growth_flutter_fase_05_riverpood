import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/mis_reservas/mis_reservas_state.dart';

class MisReservasErrorState extends MisReservasState {
  const MisReservasErrorState(this.failure);

  final AppFailure failure;
}
