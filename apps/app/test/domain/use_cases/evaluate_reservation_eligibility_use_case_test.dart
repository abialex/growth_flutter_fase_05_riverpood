import 'package:flutter_test/flutter_test.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/event.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/reservation.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/reservation_with_details.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/ticket.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/event_status.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/reservation_eligibility_status.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/reservation_status.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/ticket_status.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/evaluate_reservation_eligibility_use_case.dart';

void main() {
  const useCase = EvaluateReservationEligibilityUseCase();

  test(
    'allows a reservation when the event is open and has available slots',
    () {
      final result = useCase(
        event: _createEvent(),
        reservationDetails: null,
        seatCount: 1,
      );

      expect(result.status, ReservationEligibilityStatus.available);
      expect(result.canReserve, isTrue);
    },
  );

  test('rejects zero or negative seat counts', () {
    for (final seatCount in [0, -1]) {
      final result = useCase(
        event: _createEvent(),
        reservationDetails: null,
        seatCount: seatCount,
      );

      expect(result.status, ReservationEligibilityStatus.invalidSeatCount);
    }
  });

  test('rejects a reservation when the user already has a ticket', () {
    final result = useCase(
      event: _createEvent(),
      reservationDetails: _createReservationDetails(withTicket: true),
      seatCount: 1,
    );

    expect(result.status, ReservationEligibilityStatus.ticketPurchased);
  });

  test('rejects a second reservation for the same event', () {
    final result = useCase(
      event: _createEvent(),
      reservationDetails: _createReservationDetails(),
      seatCount: 1,
    );

    expect(result.status, ReservationEligibilityStatus.alreadyReserved);
  });

  test('rejects an event with an unknown status', () {
    final result = useCase(
      event: _createEvent(status: EventStatus.unknown),
      reservationDetails: null,
      seatCount: 1,
    );

    expect(result.status, ReservationEligibilityStatus.unknownEventStatus);
  });

  test('rejects an event with no available slots', () {
    final result = useCase(
      event: _createEvent(availableSlots: 0),
      reservationDetails: null,
      seatCount: 1,
    );

    expect(result.status, ReservationEligibilityStatus.noAvailableSlots);
  });

  test('rejects an event that is closed or finished', () {
    for (final status in [EventStatus.closed, EventStatus.finished]) {
      final result = useCase(
        event: _createEvent(status: status),
        reservationDetails: null,
        seatCount: 1,
      );

      expect(result.status, ReservationEligibilityStatus.eventClosed);
    }
  });
}

Event _createEvent({
  EventStatus status = EventStatus.open,
  int availableSlots = 5,
}) {
  return Event(
    id: 'event-1',
    name: 'Lima Football Match',
    sport: 'football',
    date: DateTime(2026, 9, 19),
    time: '10:00',
    city: 'Lima',
    venue: 'Central Stadium',
    totalSlots: 20,
    availableSlots: availableSlots,
    status: status,
  );
}

ReservationWithDetails _createReservationDetails({bool withTicket = false}) {
  final reservation = Reservation(
    id: 'reservation-1',
    userId: 'user-1',
    eventId: 'event-1',
    seatCount: 1,
    status: ReservationStatus.pending,
    reservedAt: DateTime(2026, 9, 1),
  );
  final ticket = withTicket
      ? Ticket(
          id: 'ticket-1',
          reservationId: 'reservation-1',
          code: 'TICKET-001',
          status: TicketStatus.valid,
          createdAt: DateTime(2026, 9, 1),
        )
      : null;

  return ReservationWithDetails(
    reservation: reservation,
    event: _createEvent(),
    ticket: ticket,
  );
}
