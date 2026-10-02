import 'package:flutter_test/flutter_test.dart';
import 'package:growth_flutter_fase_05_riverpood/core/enums/app_failure_type.dart';
import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/event.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/reservation.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/reservation_with_details.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/event_status.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/reservation_status.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/events_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/reservations_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/event_detail_data.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/load_event_detail_use_case.dart';
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

ReservationWithDetails _createReservationDetails({required String eventId}) {
  return ReservationWithDetails(
    reservation: Reservation(
      id: 'reservation-$eventId',
      userId: 'user-1',
      eventId: eventId,
      seatCount: 1,
      status: ReservationStatus.pending,
      reservedAt: DateTime(2026, 9, 1),
    ),
    event: _createEvent(id: eventId),
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
        failureType: AppFailureType.notFound,
        message: 'Event not found',
      );
      final eventsRepository = _MockEventsRepository();
      final reservationsRepository = _MockReservationsRepository();
      when(
        () => eventsRepository.getEventById('event-1'),
      ).thenAnswer((_) async => const Failure<Event, AppFailure>(failure));
      final useCase = LoadEventDetailUseCase(
        eventsRepository: eventsRepository,
        reservationsRepository: reservationsRepository,
      );

      final result = await useCase('event-1');

      expect(result, isA<Failure<EventDetailData, AppFailure>>());
      expect(
        (result as Failure<EventDetailData, AppFailure>).failure,
        same(failure),
      );
      verify(() => eventsRepository.getEventById('event-1')).called(1);
      verifyNever(reservationsRepository.getMyReservationsWithDetails);
    },
  );

  test(
    'returns reservation loading failure after loading the event',
    () async {
      const failure = AppFailure(
        failureType: AppFailureType.network,
        message: 'Network unavailable',
      );
      final event = _createEvent(id: 'event-1');
      final eventsRepository = _MockEventsRepository();
      final reservationsRepository = _MockReservationsRepository();
      when(
        () => eventsRepository.getEventById('event-1'),
      ).thenAnswer((_) async => Success(event));
      when(
        reservationsRepository.getMyReservationsWithDetails,
      ).thenAnswer(
        (_) async => const Failure<List<ReservationWithDetails>, AppFailure>(
          failure,
        ),
      );
      final useCase = LoadEventDetailUseCase(
        eventsRepository: eventsRepository,
        reservationsRepository: reservationsRepository,
      );

      final result = await useCase('event-1');

      expect(result, isA<Failure<EventDetailData, AppFailure>>());
      expect(
        (result as Failure<EventDetailData, AppFailure>).failure,
        same(failure),
      );
      verify(() => eventsRepository.getEventById('event-1')).called(1);
      verify(reservationsRepository.getMyReservationsWithDetails).called(1);
    },
  );

  test('returns null reservation details when none match the event', () async {
    final event = _createEvent(id: 'event-1');
    final reservationsRepository = _MockReservationsRepository();
    final eventsRepository = _MockEventsRepository();
    when(
      () => eventsRepository.getEventById('event-1'),
    ).thenAnswer((_) async => Success(event));
    when(
      reservationsRepository.getMyReservationsWithDetails,
    ).thenAnswer(
      (_) async => Success([_createReservationDetails(eventId: 'event-2')]),
    );
    final useCase = LoadEventDetailUseCase(
      eventsRepository: eventsRepository,
      reservationsRepository: reservationsRepository,
    );

    final result = await useCase('event-1');

    expect(result, isA<Success<EventDetailData, AppFailure>>());
    final data = (result as Success<EventDetailData, AppFailure>).value;
    expect(data.event, event);
    expect(data.reservationDetails, isNull);
  });

  test('returns details for the requested event and its reservation', () async {
    final event = _createEvent(id: 'event-1');
    final otherReservation = _createReservationDetails(eventId: 'event-2');
    final matchingReservation = _createReservationDetails(eventId: 'event-1');
    final eventsRepository = _MockEventsRepository();
    final reservationsRepository = _MockReservationsRepository();
    when(
      () => eventsRepository.getEventById('event-1'),
    ).thenAnswer((_) async => Success(event));
    when(
      reservationsRepository.getMyReservationsWithDetails,
    ).thenAnswer(
      (_) async => Success([otherReservation, matchingReservation]),
    );
    final useCase = LoadEventDetailUseCase(
      eventsRepository: eventsRepository,
      reservationsRepository: reservationsRepository,
    );

    final result = await useCase('event-1');

    expect(result, isA<Success<EventDetailData, AppFailure>>());
    final data = (result as Success<EventDetailData, AppFailure>).value;
    expect(data.event, event);
    expect(data.reservationDetails, same(matchingReservation));
    verify(() => eventsRepository.getEventById('event-1')).called(1);
    verify(reservationsRepository.getMyReservationsWithDetails).called(1);
  });
}
