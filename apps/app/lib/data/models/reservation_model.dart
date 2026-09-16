import 'package:growth_flutter_fase_05_riverpood/core/parsing/json_parsing.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/reserva.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/reserva_estado.dart';

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
        id: parseStringSafe(json['id']),
        userId: parseStringSafe(json['usuario_id']),
        eventId: parseStringSafe(json['evento_id']),
        seatCount: parseIntSafe(json['cantidad_cupos']),
        status: parseEnumSafe(
          json['estado'],
          values: ReservaEstado.values,
          fallback: ReservaEstado.pendiente,
        ),
        reservedAt: parseDateTimeSafe(json['fecha_reserva']),
      );

  final String id;
  final String userId;
  final String eventId;
  final int seatCount;
  final ReservaEstado status;
  final DateTime reservedAt;

  /// Converts the persistence model into the domain entity used by the app.
  Reserva toEntity() => Reserva(
    id: id,
    usuarioId: userId,
    eventoId: eventId,
    cantidadCupos: seatCount,
    estado: status,
    fechaReserva: reservedAt,
  );
}
