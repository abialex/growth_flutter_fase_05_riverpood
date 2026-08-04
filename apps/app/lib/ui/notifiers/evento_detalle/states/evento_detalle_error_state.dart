import '../../../../core/errors/app_failure.dart';
import '../evento_detalle_state.dart';

class EventoDetalleErrorState extends EventoDetalleState {
  const EventoDetalleErrorState(this.failure);

  final AppFailure failure;
}
