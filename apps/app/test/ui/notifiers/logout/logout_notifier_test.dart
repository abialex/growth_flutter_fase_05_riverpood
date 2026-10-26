import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:growth_flutter_fase_05_riverpood/core/enums/app_failure_type.dart';
import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/auth_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/login/states/login_initial_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/login/states/login_success_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/logout/logout_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/logout/states/logout_error_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/logout/states/logout_initial_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/logout/states/logout_loading_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/logout/states/logout_success_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/container.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  test(
    'shows loading and clears the login state after successful logout',
    () async {
      const email = 'person@example.com';
      const password = 'safe-password';
      final logoutResponse = Completer<Result<void, AppFailure>>();
      final repository = _MockAuthRepository();
      when(
        () => repository.signIn(email: email, password: password),
      ).thenAnswer((_) async => const Success<void, AppFailure>(null));
      when(repository.signOut).thenAnswer((_) => logoutResponse.future);
      final container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);
      final observedLogoutStates = <LogoutState>[];
      final subscription = container.listen(logoutNotifierProvider, (_, state) {
        observedLogoutStates.add(state);
      });
      addTearDown(subscription.close);

      await container
          .read(loginNotifierProvider.notifier)
          .onLogin(email: email, password: password);
      expect(container.read(loginNotifierProvider), isA<LoginSuccessState>());

      final logout = container.read(logoutNotifierProvider.notifier).onLogout();
      expect(container.read(logoutNotifierProvider), isA<LogoutLoadingState>());
      expect(container.read(loginNotifierProvider), isA<LoginSuccessState>());

      logoutResponse.complete(const Success<void, AppFailure>(null));
      await logout;

      expect(container.read(logoutNotifierProvider), isA<LogoutInitialState>());
      expect(container.read(loginNotifierProvider), isA<LoginInitialState>());
      expect(observedLogoutStates, contains(isA<LogoutSuccessState>()));
      verify(repository.signOut).called(1);
    },
  );

  test('keeps the login state when logout fails', () async {
    const email = 'person@example.com';
    const password = 'safe-password';
    const failure = AppFailure(
      failureType: AppFailureType.network,
      message: 'Network unavailable',
    );
    final repository = _MockAuthRepository();
    when(
      () => repository.signIn(email: email, password: password),
    ).thenAnswer((_) async => const Success<void, AppFailure>(null));
    when(
      repository.signOut,
    ).thenAnswer((_) async => const Failure<void, AppFailure>(failure));
    final container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    await container
        .read(loginNotifierProvider.notifier)
        .onLogin(email: email, password: password);
    await container.read(logoutNotifierProvider.notifier).onLogout();

    final logoutState = container.read(logoutNotifierProvider);
    expect(logoutState, isA<LogoutErrorState>());
    expect((logoutState as LogoutErrorState).failure, same(failure));
    expect(container.read(loginNotifierProvider), isA<LoginSuccessState>());
    verify(repository.signOut).called(1);
  });
}
