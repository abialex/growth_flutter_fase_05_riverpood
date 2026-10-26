import 'package:flutter_test/flutter_test.dart';
import 'package:growth_flutter_fase_05_riverpood/core/enums/app_failure_type.dart';
import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/reservation.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/ticket.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/reservation_status.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/ticket_status.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/purchase_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/reservations_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/confirm_purchase_use_case.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/create_reservation_use_case.dart';
import 'package:mocktail/mocktail.dart';

class _MockReservationsRepository extends Mock
    implements ReservationsRepository {}

class _MockPurchaseRepository extends Mock implements PurchaseRepository {}

void main() {
  test(
    'creates a reservation using the requested event and seat count',
    () async {
      final repository = _MockReservationsRepository();
      final reservation = Reservation(
        id: 'reservation-1',
        userId: 'user-1',
        eventId: 'event-1',
        seatCount: 2,
        status: ReservationStatus.pending,
        reservedAt: DateTime.utc(2026, 10, 20),
      );
      when(
        () => repository.createReservation(eventId: 'event-1', seatCount: 2),
      ).thenAnswer((_) async => Success(reservation));
      final useCase = CreateReservationUseCase(
        reservationsRepository: repository,
      );

      final result = await useCase(eventId: 'event-1', seatCount: 2);

      expect(result, isA<Success<Reservation, AppFailure>>());
      expect((result as Success<Reservation, AppFailure>).value, reservation);
      verify(
        () => repository.createReservation(eventId: 'event-1', seatCount: 2),
      ).called(1);
    },
  );

  test('preserves a reservation creation failure', () async {
    const failure = AppFailure(
      failureType: AppFailureType.validation,
      message: 'No seats available',
    );
    final repository = _MockReservationsRepository();
    when(
      () => repository.createReservation(eventId: 'event-1', seatCount: 2),
    ).thenAnswer((_) async => const Failure<Reservation, AppFailure>(failure));
    final useCase = CreateReservationUseCase(
      reservationsRepository: repository,
    );

    final result = await useCase(eventId: 'event-1', seatCount: 2);

    expect(result, isA<Failure<Reservation, AppFailure>>());
    expect((result as Failure<Reservation, AppFailure>).failure, same(failure));
  });

  test('confirms a purchase for the requested reservation', () async {
    final repository = _MockPurchaseRepository();
    final ticket = Ticket(
      id: 'ticket-1',
      reservationId: 'reservation-1',
      code: 'ABC-123',
      status: TicketStatus.valid,
      createdAt: DateTime.utc(2026, 10, 20),
    );
    when(
      () => repository.confirmPurchase('reservation-1'),
    ).thenAnswer((_) async => Success(ticket));
    final useCase = ConfirmPurchaseUseCase(purchaseRepository: repository);

    final result = await useCase('reservation-1');

    expect(result, isA<Success<Ticket, AppFailure>>());
    expect((result as Success<Ticket, AppFailure>).value, ticket);
    verify(() => repository.confirmPurchase('reservation-1')).called(1);
  });

  test('preserves a purchase confirmation failure', () async {
    const failure = AppFailure(
      failureType: AppFailureType.validation,
      message: 'Reservation already purchased',
    );
    final repository = _MockPurchaseRepository();
    when(
      () => repository.confirmPurchase('reservation-1'),
    ).thenAnswer((_) async => const Failure<Ticket, AppFailure>(failure));
    final useCase = ConfirmPurchaseUseCase(purchaseRepository: repository);

    final result = await useCase('reservation-1');

    expect(result, isA<Failure<Ticket, AppFailure>>());
    expect((result as Failure<Ticket, AppFailure>).failure, same(failure));
  });
}
