import 'package:flutter_test/flutter_test.dart';
import 'package:growth_flutter_fase_05_riverpood/data/models/reservation_with_details_model.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/event.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/reservation.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/ticket.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/event_status.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/reservation_status.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/ticket_status.dart';

Map<String, dynamic> _reservationWithDetailsJson({
  bool includeTicket = false,
}) {
  return {
    'reservation_id': 'reservation-1',
    'user_id': 'user-1',
    'event_id': 'event-1',
    'seat_count': 2,
    'reservation_status': 'pendiente',
    'reserved_at': '2026-09-19T09:00:00',
    'event_name': 'Lima Football Match',
    'event_sport': 'football',
    'event_date': '2026-09-19T10:00:00',
    'event_time': '10:00',
    'event_city': 'Lima',
    'event_venue': 'Central Stadium',
    'event_total_slots': 20,
    'event_available_slots': 8,
    'event_description': null,
    'event_status': 'abierto',
    if (includeTicket) ...{
      'ticket_id': 'ticket-1',
      'ticket_reservation_id': 'reservation-1',
      'ticket_code': 'TICKET-001',
      'ticket_status': 'valido',
      'ticket_created_at': '2026-09-19T11:00:00',
    },
  };
}

void main() {
  test('maps nested reservation, event, and ticket data', () {
    final model = ReservationWithDetailsModel.fromJson(
      _reservationWithDetailsJson(includeTicket: true),
    );

    final details = model.toEntity();
    expect(
      details.reservation,
      Reservation(
        id: 'reservation-1',
        userId: 'user-1',
        eventId: 'event-1',
        seatCount: 2,
        status: ReservationStatus.pending,
        reservedAt: DateTime(2026, 9, 19, 9),
      ),
    );
    expect(
      details.event,
      Event(
        id: 'event-1',
        name: 'Lima Football Match',
        sport: 'football',
        date: DateTime(2026, 9, 19, 10),
        time: '10:00',
        city: 'Lima',
        venue: 'Central Stadium',
        totalSlots: 20,
        availableSlots: 8,
        status: EventStatus.open,
      ),
    );
    expect(
      details.ticket,
      Ticket(
        id: 'ticket-1',
        reservationId: 'reservation-1',
        code: 'TICKET-001',
        status: TicketStatus.valid,
        createdAt: DateTime(2026, 9, 19, 11),
      ),
    );
  });

  test('leaves ticket null when ticket fields are absent from the JSON', () {
    final model = ReservationWithDetailsModel.fromJson(
      _reservationWithDetailsJson(),
    );

    expect(model.toEntity().ticket, isNull);
  });
}
