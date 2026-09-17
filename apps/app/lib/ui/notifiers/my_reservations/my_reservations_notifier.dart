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
    final operationId = _operationGuard.start();
    state = const MyReservationsLoadingState();
    final loadMyReservations = ref.read(loadMyReservationsUseCaseProvider);
    final result = await loadMyReservations();
    if (!_operationGuard.isCurrent(operationId)) return;

    state = switch (result) {
      Success(value: final data) => MyReservationsLoadedState(
        reservations: data.reservations,
        eventsById: data.eventsById,
        ticketsByReservationId: data.ticketsByReservationId,
      ),
      Failure(failure: final failure) => MyReservationsErrorState(failure),
    };
  }
}
