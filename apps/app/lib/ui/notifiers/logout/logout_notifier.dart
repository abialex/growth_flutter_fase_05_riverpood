import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/logout/logout_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/logout/states/logout_error_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/logout/states/logout_initial_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/logout/states/logout_loading_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/logout/states/logout_success_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/auth_repository_providers.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/eventos_providers.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/reservas_providers.dart';

/// Coordinates logout and clears authenticated feature state.
class LogoutNotifier extends Notifier<LogoutState> {
  @override
  LogoutState build() => const LogoutInitialState();

  /// Signs out the current user and invalidates authenticated state.
  Future<void> logout() async {
    state = const LogoutLoadingState();

    final authRepository = ref.read(authRepositoryProvider);
    final result = await authRepository.signOut();

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
      ..invalidate(eventosNotifierProvider)
      ..invalidate(eventoDetalleNotifierProvider)
      ..invalidate(reservarNotifierProvider)
      ..invalidate(confirmarCompraNotifierProvider)
      ..invalidate(misReservasNotifierProvider);
  }
}
