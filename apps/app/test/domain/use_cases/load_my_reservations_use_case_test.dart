import 'package:flutter_test/flutter_test.dart';
import 'package:growth_flutter_fase_05_riverpood/core/enums/app_failure_type.dart';
import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/event.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/reservation.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/reservation_with_details.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/event_status.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/reservation_status.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/reservations_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/load_my_reservations_use_case.dart';
import 'package:mocktail/mocktail.dart';

class _MockReservationsRepository extends Mock
    implements ReservationsRepository {}

void main() {
  test(
    'returns the current user reservations with their event details',
    () async {
      final reservationDetails = ReservationWithDetails(
        reservation: Reservation(
          id: 'reservation-1',
          userId: 'user-1',
          eventId: 'event-1',
          seatCount: 2,
          status: ReservationStatus.pending,
          reservedAt: DateTime.utc(2026, 10, 20),
        ),
        event: Event(
          id: 'event-1',
          name: 'Football Match',
          sport: 'football',
          date: DateTime.utc(2026, 11),
          time: '10:00',
          city: 'Lima',
          venue: 'Central Stadium',
          totalSlots: 20,
          availableSlots: 18,
          status: EventStatus.open,
        ),
      );
      final repository = _MockReservationsRepository();
      when(
        repository.getMyReservationsWithDetails,
      ).thenAnswer((_) async => Success([reservationDetails]));
      final useCase = LoadMyReservationsUseCase(
        reservationsRepository: repository,
      );

      final result = await useCase();

      expect(result, isA<Success<List<ReservationWithDetails>, AppFailure>>());
      expect(
        (result as Success<List<ReservationWithDetails>, AppFailure>).value,
        [reservationDetails],
      );
      verify(repository.getMyReservationsWithDetails).called(1);
    },
  );

  test(
    'preserves the repository failure when loading reservations fails',
    () async {
      const failure = AppFailure(
        failureType: AppFailureType.network,
        message: 'Network unavailable',
      );
      final repository = _MockReservationsRepository();
      when(
        repository.getMyReservationsWithDetails,
      ).thenAnswer(
        (_) async => const Failure<List<ReservationWithDetails>, AppFailure>(
          failure,
        ),
      );
      final useCase = LoadMyReservationsUseCase(
        reservationsRepository: repository,
      );

      final result = await useCase();

      expect(result, isA<Failure<List<ReservationWithDetails>, AppFailure>>());
      expect(
        (result as Failure<List<ReservationWithDetails>, AppFailure>).failure,
        same(failure),
      );
    },
  );
}
