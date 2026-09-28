import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growth_flutter_fase_05_riverpood/core/async/async_operation_guard.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/auth_status.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/auth_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/container.dart';

/// Publishes the single authentication status used by the application.
class AuthNotifier extends Notifier<AuthStatus> {
  final AsyncOperationGuard _operationGuard = AsyncOperationGuard();

  @override
  AuthStatus build() {
    final authRepository = ref.watch(authRepositoryProvider);
    final subscription = authRepository.authStatusChanges.listen(
      (status) => state = status,
    );

    ref.onDispose(() {
      _operationGuard.cancel();
      unawaited(subscription.cancel());
    });

    final operationId = _operationGuard.start();
    unawaited(_resolveInitialStatus(authRepository, operationId));
    return AuthStatus.loading;
  }

  Future<void> _resolveInitialStatus(
    AuthRepository authRepository,
    int operationId,
  ) async {
    await Future<void>.delayed(Duration.zero);
    if (!_operationGuard.isCurrent(operationId)) return;

    state = authRepository.isAuthenticated
        ? AuthStatus.authenticated
        : AuthStatus.unauthenticated;
  }
}
