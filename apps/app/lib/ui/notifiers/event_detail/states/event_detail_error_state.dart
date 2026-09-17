import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/event_detail/event_detail_state.dart';

class EventDetailErrorState extends EventDetailState {
  const EventDetailErrorState(this.failure);

  final AppFailure failure;
}
