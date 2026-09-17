/// Describes the lifecycle status of a reservation.
enum ReservationStatus {
  /// The reservation is awaiting confirmation.
  /// The current flow allows this state to transition to [confirmed].
  pending,

  /// The reservation has been confirmed.
  /// This is a terminal state in the current application scope.
  confirmed,

  /// The reservation has been cancelled.
  /// No cancellation operation is exposed in the current application scope.
  cancelled,
}
