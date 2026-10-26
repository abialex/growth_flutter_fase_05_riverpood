import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:growth_flutter_fase_05_riverpood/core/enums/app_failure_type.dart';
import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/auth_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/login_use_case.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/login/states/login_error_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/login/states/login_initial_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/login/states/login_loading_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/login/states/login_success_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/auth_providers.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  const email = 'person@example.com';
  const password = 'correct-horse-battery-staple';

  ProviderContainer createContainer(AuthRepository repository) {
    return ProviderContainer(
      overrides: [
        loginUseCaseProvider.overrideWithValue(
          LoginUseCase(authRepository: repository),
        ),
      ],
    );
  }

  test(
    'exposes the authentication failure returned by the repository',
    () async {
      const failure = AppFailure(
        failureType: AppFailureType.unauthorized,
        message: 'Invalid login credentials',
      );
      final repository = _MockAuthRepository();
      when(
        () => repository.signIn(email: email, password: password),
      ).thenAnswer((_) async => const Failure<void, AppFailure>(failure));
      final container = createContainer(repository);
      addTearDown(container.dispose);

      await container
          .read(loginNotifierProvider.notifier)
          .onLogin(email: email, password: password);

      final state = container.read(loginNotifierProvider);
      expect(state, isA<LoginErrorState>());
      expect((state as LoginErrorState).failure, same(failure));
      verify(
        () => repository.signIn(email: email, password: password),
      ).called(1);
    },
  );

  test(
    'emits loading, succeeds, and resets after the result is consumed',
    () async {
      final response = Completer<Result<void, AppFailure>>();
      final repository = _MockAuthRepository();
      when(
        () => repository.signIn(email: email, password: password),
      ).thenAnswer((_) => response.future);
      final container = createContainer(repository);
      addTearDown(container.dispose);
      final notifier = container.read(loginNotifierProvider.notifier);

      final login = notifier.onLogin(email: email, password: password);
      expect(container.read(loginNotifierProvider), isA<LoginLoadingState>());

      response.complete(const Success<void, AppFailure>(null));
      await login;
      expect(container.read(loginNotifierProvider), isA<LoginSuccessState>());

      notifier.reset();
      expect(container.read(loginNotifierProvider), isA<LoginInitialState>());
      verify(
        () => repository.signIn(email: email, password: password),
      ).called(1);
    },
  );
}
