import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:growth_flutter_fase_05_riverpood/core/enums/app_failure_type.dart';
import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/reservation_with_details.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/reservations_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/load_my_reservations_use_case.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/my_reservations/states/my_reservations_error_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/my_reservations/states/my_reservations_loading_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/reservation_providers.dart';
import 'package:mocktail/mocktail.dart';

class _MockReservationsRepository extends Mock
    implements ReservationsRepository {}

void main() {
  test('shows the initial loading failure for my reservations', () async {
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
    final container = ProviderContainer(
      overrides: [
        loadMyReservationsUseCaseProvider.overrideWithValue(
          LoadMyReservationsUseCase(reservationsRepository: repository),
        ),
      ],
    );
    addTearDown(container.dispose);
    final notifier = container.read(myReservationsNotifierProvider.notifier);

    final loading = notifier.loadMyReservations();
    expect(
      container.read(myReservationsNotifierProvider),
      isA<MyReservationsLoadingState>(),
    );

    await loading;

    final state = container.read(myReservationsNotifierProvider);
    expect(state, isA<MyReservationsErrorState>());
    expect((state as MyReservationsErrorState).failure, same(failure));
    verify(repository.getMyReservationsWithDetails).called(1);
  });
}
