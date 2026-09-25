import 'package:growth_flutter_fase_05_riverpood/domain/entities/event.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/reservation_eligibility.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/event_status.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/reservation_eligibility_status.dart';

/// Evaluates whether the current user can reserve an event.
final class EvaluateReservationEligibilityUseCase {
  /// Creates a reservation eligibility evaluator.
  const EvaluateReservationEligibilityUseCase();

  /// Evaluates the reservation request for [event] and [seatCount].
  ReservationEligibility call({
    required Event event,
    required bool isReserved,
    required int seatCount,
  }) {
    // Reject requests that do not include a positive number of seats.
    if (seatCount <= 0) {
      return const ReservationEligibility(
        status: ReservationEligibilityStatus.invalidSeatCount,
      );
    }

    // Prevent the user from creating a second reservation for the same event.
    if (isReserved) {
      return const ReservationEligibility(
        status: ReservationEligibilityStatus.alreadyReserved,
      );
    }

    // Do not allow reservations when the event status cannot be trusted.
    if (event.status == EventStatus.unknown) {
      return const ReservationEligibility(
        status: ReservationEligibilityStatus.unknownEventStatus,
      );
    }

    // Reject reservations when the event has no remaining slots.
    if (event.availableSlots <= 0) {
      return const ReservationEligibility(
        status: ReservationEligibilityStatus.noAvailableSlots,
      );
    }

    // Reject events that are closed or otherwise not accepting reservations.
    if (!event.canAcceptReservations) {
      return const ReservationEligibility(
        status: ReservationEligibilityStatus.eventClosed,
      );
    }

    // Allow the reservation when every eligibility rule has passed.
    return const ReservationEligibility(
      status: ReservationEligibilityStatus.available,
    );
  }
}
