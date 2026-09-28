/// Describes the current user's relationship with an event.
enum EventReservationStatus {
  /// The user has no reservation for the event.
  none,

  /// The user reserved the event but has no ticket yet.
  reserved,

  /// The user completed the purchase and has a ticket.
  purchased,
}
