import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/evento_detalle/evento_detalle_state.dart';

class EventoDetalleErrorState extends EventoDetalleState {
  const EventoDetalleErrorState(this.failure);

  final AppFailure failure;
}
