import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growth_flutter_fase_05_riverpood/core/async/async_operation_guard.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/my_reservations/my_reservations_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/my_reservations/states/my_reservations_error_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/my_reservations/states/my_reservations_initial_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/my_reservations/states/my_reservations_loaded_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/my_reservations/states/my_reservations_loading_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/container.dart';

class MyReservationsNotifier extends Notifier<MyReservationsState> {
  final AsyncOperationGuard _operationGuard = AsyncOperationGuard();

  @override
  MyReservationsState build() {
    ref.onDispose(_operationGuard.cancel);
    return const MyReservationsInitialState();
  }

  Future<void> loadMyReservations() async {
    final previousState = state;
    final previousLoadedState = previousState is MyReservationsLoadedState
        ? previousState
        : null;
    final operationId = _operationGuard.start();
    if (previousLoadedState == null) {
      state = const MyReservationsLoadingState();
    } else {
      state = MyReservationsLoadedState(
        reservations: previousLoadedState.reservations,
        isRefreshing: true,
      );
    }

    final loadMyReservations = ref.read(loadMyReservationsUseCaseProvider);
    final result = await loadMyReservations();
    if (!_operationGuard.isCurrent(operationId)) return;

    if (previousLoadedState == null) {
      state = switch (result) {
        Success(value: final reservations) => MyReservationsLoadedState(
          reservations: reservations,
        ),
        Failure(failure: final failure) => MyReservationsErrorState(failure),
      };
      return;
    }

    state = switch (result) {
      Success(value: final reservations) => MyReservationsLoadedState(
        reservations: reservations,
      ),
      Failure(failure: final failure) => MyReservationsLoadedState(
        reservations: previousLoadedState.reservations,
        refreshFailure: failure,
      ),
    };
  }
}
