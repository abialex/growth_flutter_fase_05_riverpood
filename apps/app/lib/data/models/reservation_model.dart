import 'package:growth_flutter_fase_05_riverpood/core/parsing/json_parsing.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/reservation.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/reservation_status.dart';

/// Persistence representation of a reservation returned by Supabase.
final class ReservationModel {
  const ReservationModel({
    required this.id,
    required this.userId,
    required this.eventId,
    required this.seatCount,
    required this.status,
    required this.reservedAt,
  });

  /// Creates a model from a Supabase row without assuming JSON types.
  factory ReservationModel.fromJson(Map<String, dynamic> json) =>
      ReservationModel(
        id: parseRequiredString(json['id'], field: 'id'),
        userId: parseRequiredString(json['usuario_id'], field: 'usuario_id'),
        eventId: parseRequiredString(json['evento_id'], field: 'evento_id'),
        seatCount: parseRequiredInt(
          json['cantidad_cupos'],
          field: 'cantidad_cupos',
          minimum: 1,
        ),
        status: _parseReservationStatus(
          parseRequiredString(json['estado'], field: 'estado'),
        ),
        reservedAt: parseRequiredDateTime(
          json['fecha_reserva'],
          field: 'fecha_reserva',
        ),
      );

  final String id;
  final String userId;
  final String eventId;
  final int seatCount;
  final ReservationStatus status;
  final DateTime reservedAt;

  /// Converts the persistence model into the domain entity used by the app.
  Reservation toEntity() => Reservation(
    id: id,
    userId: userId,
    eventId: eventId,
    seatCount: seatCount,
    status: status,
    reservedAt: reservedAt,
  );
}

ReservationStatus _parseReservationStatus(String value) => switch (value) {
  'pendiente' => ReservationStatus.pending,
  'confirmada' => ReservationStatus.confirmed,
  'cancelada' => ReservationStatus.cancelled,
  _ => ReservationStatus.pending,
};
