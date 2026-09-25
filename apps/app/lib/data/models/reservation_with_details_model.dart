import 'package:growth_flutter_fase_05_riverpood/data/models/event_model.dart';
import 'package:growth_flutter_fase_05_riverpood/data/models/reservation_model.dart';
import 'package:growth_flutter_fase_05_riverpood/data/models/ticket_model.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/reservation_with_details.dart';

/// Persistence representation of a reservation detail row.
final class ReservationWithDetailsModel {
  const ReservationWithDetailsModel({
    required this.reservation,
    required this.event,
    this.ticket,
  });

  /// Creates a model from the reservation detail RPC response.
  factory ReservationWithDetailsModel.fromJson(Map<String, dynamic> json) {
    final reservation = ReservationModel.fromJson({
      'id': json['reservation_id'],
      'usuario_id': json['user_id'],
      'evento_id': json['event_id'],
      'cantidad_cupos': json['seat_count'],
      'estado': json['reservation_status'],
      'fecha_reserva': json['reserved_at'],
    });
    final event = EventModel.fromJson({
      'id': json['event_id'],
      'nombre': json['event_name'],
      'deporte': json['event_sport'],
      'fecha': json['event_date'],
      'hora': json['event_time'],
      'ciudad': json['event_city'],
      'lugar': json['event_venue'],
      'cupos_totales': json['event_total_slots'],
      'cupos_disponibles': json['event_available_slots'],
      'descripcion': json['event_description'],
      'estado': json['event_status'],
    });

    final ticketId = json['ticket_id'];
    final ticket = ticketId == null
        ? null
        : TicketModel.fromJson({
            'id': ticketId,
            'reserva_id': json['ticket_reservation_id'],
            'codigo': json['ticket_code'],
            'estado': json['ticket_status'],
            'created_at': json['ticket_created_at'],
          });

    return ReservationWithDetailsModel(
      reservation: reservation,
      event: event,
      ticket: ticket,
    );
  }

  final ReservationModel reservation;
  final EventModel event;
  final TicketModel? ticket;

  /// Converts this persistence model to the domain aggregate.
  ReservationWithDetails toEntity() => ReservationWithDetails(
    reservation: reservation.toEntity(),
    event: event.toEntity(),
    ticket: ticket?.toEntity(),
  );
}
