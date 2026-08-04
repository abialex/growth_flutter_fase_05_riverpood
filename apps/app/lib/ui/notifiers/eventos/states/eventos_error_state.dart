import '../../../../core/errors/app_failure.dart';
import '../eventos_state.dart';

class EventosErrorState extends EventosState {
  const EventosErrorState(this.failure);

  final AppFailure failure;
}
