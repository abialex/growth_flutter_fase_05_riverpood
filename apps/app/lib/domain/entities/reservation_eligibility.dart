import 'package:growth_flutter_fase_05_riverpood/domain/enums/reservation_eligibility_status.dart';
import 'package:meta/meta.dart';

/// Contains the domain decision for creating a reservation.
@immutable
final class ReservationEligibility {
  /// Creates a reservation eligibility result.
  const ReservationEligibility({required this.status});

  /// The reason for the reservation decision.
  final ReservationEligibilityStatus status;

  /// Whether the reservation action is currently allowed.
  bool get canReserve {
    return status == ReservationEligibilityStatus.available;
  }

  /// Whether the current user already reserved this event.
  bool get isAlreadyReserved {
    return status == ReservationEligibilityStatus.alreadyReserved;
  }

  /// Whether the current user already purchased a ticket for this event.
  bool get isTicketPurchased {
    return status == ReservationEligibilityStatus.ticketPurchased;
  }

  /// Returns the action label or blocking message for the reservation area.
  String get actionLabel => switch (status) {
    ReservationEligibilityStatus.available => 'Reservar cupo',
    ReservationEligibilityStatus.alreadyReserved =>
      'Ya tienes una reserva para este evento.',
    ReservationEligibilityStatus.ticketPurchased =>
      'Ya compraste un ticket para este evento.',
    ReservationEligibilityStatus.invalidSeatCount => 'Cantidad no válida',
    ReservationEligibilityStatus.unknownEventStatus => 'Estado desconocido',
    ReservationEligibilityStatus.noAvailableSlots => 'Sin cupos disponibles',
    ReservationEligibilityStatus.eventClosed => 'Reservas cerradas',
  };
}
