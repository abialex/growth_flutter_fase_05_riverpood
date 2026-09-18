import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:growth_flutter_fase_05_riverpood/core/async/async_operation_guard.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/logout/logout_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/logout/states/logout_error_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/logout/states/logout_initial_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/logout/states/logout_loading_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/logout/states/logout_success_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/container.dart';

/// Coordinates logout and clears authenticated feature state.
class LogoutNotifier extends Notifier<LogoutState> {
  final AsyncOperationGuard _operationGuard = AsyncOperationGuard();

  @override
  LogoutState build() {
    ref.onDispose(_operationGuard.cancel);
    return const LogoutInitialState();
  }

  /// Signs out the current user and invalidates authenticated state.
  Future<void> onLogout() async {
    if (state is LogoutLoadingState) return;

    final operationId = _operationGuard.start();
    state = const LogoutLoadingState();

    final logoutUseCase = ref.read(logoutUseCaseProvider);
    final result = await logoutUseCase();
    if (!_operationGuard.isCurrent(operationId)) return;

    state = switch (result) {
      Success() => const LogoutSuccessState(),
      Failure(failure: final failure) => LogoutErrorState(failure),
    };

    if (result case Success()) {
      _clearAuthenticatedState();
    }
  }

  void _clearAuthenticatedState() {
    ref
      ..invalidate(loginNotifierProvider)
      ..invalidate(eventsNotifierProvider)
      ..invalidate(eventDetailNotifierProvider)
      ..invalidate(createReservationNotifierProvider)
      ..invalidate(confirmPurchaseNotifierProvider)
      ..invalidate(myReservationsNotifierProvider);
  }
}
