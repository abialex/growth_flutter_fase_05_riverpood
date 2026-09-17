import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/events/events_state.dart';

class EventsErrorState extends EventsState {
  const EventsErrorState(this.failure);

  final AppFailure failure;
}
