import 'package:flutter_test/flutter_test.dart';
import 'package:growth_flutter_fase_05_riverpood/core/enums/app_failure_type.dart';
import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/event.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/reservation.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/reservation_with_details.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/ticket.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/event_reservation_status.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/event_status.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/reservation_status.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/ticket_status.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/events_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/reservations_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/events_data.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/load_events_with_reservation_markers_use_case.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/use_case.dart';
import 'package:mocktail/mocktail.dart';

Event _createEvent({required String id}) {
  return Event(
    id: id,
    name: 'Football Match',
    sport: 'football',
    date: DateTime(2026, 9, 19),
    time: '10:00',
    city: 'Lima',
    venue: 'Central Stadium',
    totalSlots: 20,
    availableSlots: 10,
    status: EventStatus.open,
  );
}

ReservationWithDetails _createReservationDetails({
  required String eventId,
  bool withTicket = false,
}) {
  final reservation = Reservation(
    id: 'reservation-$eventId-${withTicket ? 'ticketed' : 'pending'}',
    userId: 'user-1',
    eventId: eventId,
    seatCount: 1,
    status: ReservationStatus.pending,
    reservedAt: DateTime(2026, 9),
  );
  final ticket = withTicket
      ? Ticket(
          id: 'ticket-$eventId',
          reservationId: reservation.id,
          code: 'TICKET-$eventId',
          status: TicketStatus.valid,
          createdAt: DateTime(2026, 9, 2),
        )
      : null;

  return ReservationWithDetails(
    reservation: reservation,
    event: _createEvent(id: eventId),
    ticket: ticket,
  );
}

class _MockEventsRepository extends Mock implements EventsRepository {}

class _MockReservationsRepository extends Mock
    implements ReservationsRepository {}

void main() {
  test(
    'returns event loading failure without requesting reservations',
    () async {
      const failure = AppFailure(
        failureType: AppFailureType.network,
        message: 'Network unavailable',
      );
      final eventsRepository = _MockEventsRepository();
      final reservationsRepository = _MockReservationsRepository();
      when(eventsRepository.getEvents).thenAnswer(
        (_) async => const Failure<List<Event>, AppFailure>(failure),
      );
      final useCase = LoadEventsWithReservationMarkersUseCase(
        eventsRepository: eventsRepository,
        reservationsRepository: reservationsRepository,
      );

      final result = await useCase(const NoParams());

      expect(result, isA<Failure<EventsData, AppFailure>>());
      expect(
        (result as Failure<EventsData, AppFailure>).failure,
        same(failure),
      );
      verify(eventsRepository.getEvents).called(1);
      verifyNever(reservationsRepository.getMyReservationsWithDetails);
    },
  );

  test(
    'returns reservation loading failure after loading events',
    () async {
      const failure = AppFailure(
        failureType: AppFailureType.network,
        message: 'Network unavailable',
      );
      final events = [_createEvent(id: 'event-1')];
      final eventsRepository = _MockEventsRepository();
      final reservationsRepository = _MockReservationsRepository();
      when(
        eventsRepository.getEvents,
      ).thenAnswer((_) async => Success(events));
      when(
        reservationsRepository.getMyReservationsWithDetails,
      ).thenAnswer(
        (_) async => const Failure<List<ReservationWithDetails>, AppFailure>(
          failure,
        ),
      );
      final useCase = LoadEventsWithReservationMarkersUseCase(
        eventsRepository: eventsRepository,
        reservationsRepository: reservationsRepository,
      );

      final result = await useCase(const NoParams());

      expect(result, isA<Failure<EventsData, AppFailure>>());
      expect(
        (result as Failure<EventsData, AppFailure>).failure,
        same(failure),
      );
      verify(eventsRepository.getEvents).called(1);
      verify(reservationsRepository.getMyReservationsWithDetails).called(1);
    },
  );

  test(
    'marks reserved and purchased events while preserving event order',
    () async {
      final events = [
        _createEvent(id: 'event-1'),
        _createEvent(id: 'event-2'),
        _createEvent(id: 'event-3'),
      ];
      final reservations = [
        _createReservationDetails(eventId: 'event-1'),
        _createReservationDetails(eventId: 'event-2', withTicket: true),
        _createReservationDetails(eventId: 'event-2'),
      ];
      final eventsRepository = _MockEventsRepository();
      final reservationsRepository = _MockReservationsRepository();
      when(
        eventsRepository.getEvents,
      ).thenAnswer((_) async => Success(events));
      when(
        reservationsRepository.getMyReservationsWithDetails,
      ).thenAnswer((_) async => Success(reservations));

      final useCase = LoadEventsWithReservationMarkersUseCase(
        eventsRepository: eventsRepository,
        reservationsRepository: reservationsRepository,
      );

      final result = await useCase(const NoParams());

      expect(result, isA<Success<EventsData, AppFailure>>());
      final data = (result as Success<EventsData, AppFailure>).value;
      expect(data.events, events);
      expect(
        data.eventReservationStatuses,
        {
          'event-1': EventReservationStatus.reserved,
          'event-2': EventReservationStatus.purchased,
        },
      );
      expect(data.events.map((event) => event.id), [
        'event-1',
        'event-2',
        'event-3',
      ]);
      verify(eventsRepository.getEvents).called(1);
      verify(
        reservationsRepository.getMyReservationsWithDetails,
      ).called(1);
    },
  );
}
