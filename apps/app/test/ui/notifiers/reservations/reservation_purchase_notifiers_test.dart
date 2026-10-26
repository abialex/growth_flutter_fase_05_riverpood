import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservations/states/confirm_purchase_error_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservations/states/confirm_purchase_loading_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservations/states/confirm_purchase_success_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservations/states/create_reservation_error_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservations/states/create_reservation_loading_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservations/states/create_reservation_success_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/container.dart';
import 'package:mocktail/mocktail.dart';

class _MockReservationsRepository extends Mock
    implements ReservationsRepository {}

class _MockPurchaseRepository extends Mock implements PurchaseRepository {}

void main() {
  test(
    'shows loading and the returned failure when reservation creation fails',
    () async {
      const failure = AppFailure(
        failureType: AppFailureType.validation,
        message: 'No seats available',
      );
      final response = Completer<Result<Reservation, AppFailure>>();
      final repository = _MockReservationsRepository();
      when(
        () => repository.createReservation(eventId: 'event-1', seatCount: 2),
      ).thenAnswer((_) => response.future);
      final container = ProviderContainer(
        overrides: [
          createReservationUseCaseProvider.overrideWithValue(
            CreateReservationUseCase(reservationsRepository: repository),
          ),
        ],
      );
      addTearDown(container.dispose);
      final create = container
          .read(createReservationNotifierProvider.notifier)
          .onCreateReservation(eventId: 'event-1', seatCount: 2);

      expect(
        container.read(createReservationNotifierProvider),
        isA<CreateReservationLoadingState>(),
      );
      response.complete(const Failure<Reservation, AppFailure>(failure));
      await create;

      final state = container.read(createReservationNotifierProvider);
      expect(state, isA<CreateReservationErrorState>());
      expect((state as CreateReservationErrorState).failure, same(failure));
      verify(
        () => repository.createReservation(eventId: 'event-1', seatCount: 2),
      ).called(1);
    },
  );

  test('sets success after creating a reservation', () async {
    final repository = _MockReservationsRepository();
    when(
      () => repository.createReservation(eventId: 'event-1', seatCount: 1),
    ).thenAnswer(
      (_) async => Success(
        Reservation(
          id: 'reservation-1',
          userId: 'user-1',
          eventId: 'event-1',
          seatCount: 1,
          status: ReservationStatus.pending,
          reservedAt: DateTime.utc(2026, 10, 20),
        ),
      ),
    );
    final container = ProviderContainer(
      overrides: [
        createReservationUseCaseProvider.overrideWithValue(
          CreateReservationUseCase(reservationsRepository: repository),
        ),
      ],
    );
    addTearDown(container.dispose);

    await container
        .read(createReservationNotifierProvider.notifier)
        .onCreateReservation(eventId: 'event-1', seatCount: 1);

    expect(
      container.read(createReservationNotifierProvider),
      isA<CreateReservationSuccessState>(),
    );
  });

  test('keeps the reservation id in the purchase error state', () async {
    const reservationId = 'reservation-1';
    const failure = AppFailure(
      failureType: AppFailureType.validation,
      message: 'Reservation already purchased',
    );
    final repository = _MockPurchaseRepository();
    when(
      () => repository.confirmPurchase(reservationId),
    ).thenAnswer((_) async => const Failure<Ticket, AppFailure>(failure));
    final container = ProviderContainer(
      overrides: [
        confirmPurchaseUseCaseProvider.overrideWithValue(
          ConfirmPurchaseUseCase(purchaseRepository: repository),
        ),
      ],
    );
    addTearDown(container.dispose);

    await container
        .read(confirmPurchaseNotifierProvider.notifier)
        .onConfirmPurchase(reservationId);

    final state = container.read(confirmPurchaseNotifierProvider);
    expect(state, isA<ConfirmPurchaseErrorState>());
    expect((state as ConfirmPurchaseErrorState).reservationId, reservationId);
    expect(state.failure, same(failure));
  });

  test('emits loading and success for the confirmed reservation', () async {
    const reservationId = 'reservation-1';
    final response = Completer<Result<Ticket, AppFailure>>();
    final repository = _MockPurchaseRepository();
    when(
      () => repository.confirmPurchase(reservationId),
    ).thenAnswer((_) => response.future);
    final container = ProviderContainer(
      overrides: [
        confirmPurchaseUseCaseProvider.overrideWithValue(
          ConfirmPurchaseUseCase(purchaseRepository: repository),
        ),
      ],
    );
    addTearDown(container.dispose);
    final purchase = container
        .read(confirmPurchaseNotifierProvider.notifier)
        .onConfirmPurchase(reservationId);

    expect(
      container.read(confirmPurchaseNotifierProvider),
      isA<ConfirmPurchaseLoadingState>().having(
        (state) => state.reservationId,
        'reservationId',
        reservationId,
      ),
    );
    response.complete(
      Success(
        Ticket(
          id: 'ticket-1',
          reservationId: reservationId,
          code: 'ABC-123',
          status: TicketStatus.valid,
          createdAt: DateTime.utc(2026, 10, 20),
        ),
      ),
    );
    await purchase;

    expect(
      container.read(confirmPurchaseNotifierProvider),
      isA<ConfirmPurchaseSuccessState>().having(
        (state) => state.reservationId,
        'reservationId',
        reservationId,
      ),
    );
  });
}
