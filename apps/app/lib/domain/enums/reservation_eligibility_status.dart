/// Describes why a reservation can or cannot be created.
enum ReservationEligibilityStatus {
  /// The event can be reserved with the requested seat count.
  available,

  /// The current user already has an active reservation for the event.
  alreadyReserved,

  /// The requested seat count is invalid.
  invalidSeatCount,

  /// The event status is not recognized by the application.
  unknownEventStatus,

  /// The event has no available seats.
  noAvailableSlots,

  /// The event is not open for reservations.
  eventClosed,
}
