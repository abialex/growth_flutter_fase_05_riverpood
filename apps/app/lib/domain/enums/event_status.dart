/// Describes the lifecycle status of an event.
enum EventStatus {
  /// The event accepts reservations.
  open,

  /// The event is not accepting reservations.
  closed,

  /// The event has already ended.
  finished,

  /// The backend returned a status that this app does not know.
  unknown,
}
