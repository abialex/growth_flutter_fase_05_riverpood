import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/eventos/eventos_state.dart';

class EventosErrorState extends EventosState {
  const EventosErrorState(this.failure);

  final AppFailure failure;
}
