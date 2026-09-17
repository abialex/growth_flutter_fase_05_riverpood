/// Describes the lifecycle status of a reservation.
enum ReservationStatus {
  /// The reservation is awaiting confirmation.
  pending,

  /// The reservation has been confirmed.
  confirmed,

  /// The reservation has been cancelled.
  cancelled,
}
