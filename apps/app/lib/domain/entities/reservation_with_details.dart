import 'package:growth_flutter_fase_05_riverpood/domain/entities/event.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/reservation.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/ticket.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/reservation_status.dart';
import 'package:meta/meta.dart';

/// Represents a reservation with its event and optional ticket.
@immutable
final class ReservationWithDetails {
  /// Creates a reservation detail entry.
  const ReservationWithDetails({
    required this.reservation,
    required this.event,
    this.ticket,
  });

  /// The reservation made by the user.
  final Reservation reservation;

  /// The event linked to the reservation.
  final Event event;

  /// The ticket linked to the reservation, when one exists.
  final Ticket? ticket;

  /// Whether the current user's reservation can be confirmed.
  bool get canConfirmPurchase {
    return reservation.status == ReservationStatus.pending && ticket == null;
  }
}
