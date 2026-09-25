import 'package:growth_flutter_fase_05_riverpood/domain/entities/event.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/reservation_eligibility.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/event_detail/event_detail_state.dart';

class EventDetailLoadedState extends EventDetailState {
  const EventDetailLoadedState({
    required this.event,
    required this.reservationEligibility,
  });

  final Event event;
  final ReservationEligibility reservationEligibility;
}
