import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:growth_flutter_fase_05_riverpood/core/enums/app_failure_type.dart';
import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/auth_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/register_use_case.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/register/states/register_error_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/register/states/register_initial_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/register/states/register_success_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/auth_providers.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  const email = 'new.person@example.com';
  const password = 'safe-password';
  const name = 'New Person';

  ProviderContainer createContainer(AuthRepository repository) {
    return ProviderContainer(
      overrides: [
        registerUseCaseProvider.overrideWithValue(
          RegisterUseCase(authRepository: repository),
        ),
      ],
    );
  }

  test('returns the repository failure when account creation fails', () async {
    const failure = AppFailure(
      failureType: AppFailureType.validation,
      message: 'Email already registered',
    );
    final repository = _MockAuthRepository();
    when(
      () => repository.signUp(
        email: email,
        password: password,
        name: name,
      ),
    ).thenAnswer((_) async => const Failure<void, AppFailure>(failure));
    final container = createContainer(repository);
    addTearDown(container.dispose);

    await container
        .read(registerNotifierProvider.notifier)
        .onRegister(email: email, password: password, name: name);

    final state = container.read(registerNotifierProvider);
    expect(state, isA<RegisterErrorState>());
    expect((state as RegisterErrorState).failure, same(failure));
    verify(
      () => repository.signUp(
        email: email,
        password: password,
        name: name,
      ),
    ).called(1);
  });

  test('registers with the optional city and resets after success', () async {
    const city = 'Lima';
    final repository = _MockAuthRepository();
    when(
      () => repository.signUp(
        email: email,
        password: password,
        name: name,
        city: city,
      ),
    ).thenAnswer((_) async => const Success<void, AppFailure>(null));
    final container = createContainer(repository);
    addTearDown(container.dispose);
    final notifier = container.read(registerNotifierProvider.notifier);

    await notifier.onRegister(
      email: email,
      password: password,
      name: name,
      city: city,
    );
    expect(
      container.read(registerNotifierProvider),
      isA<RegisterSuccessState>(),
    );

    notifier.reset();
    expect(
      container.read(registerNotifierProvider),
      isA<RegisterInitialState>(),
    );
    verify(
      () => repository.signUp(
        email: email,
        password: password,
        name: name,
        city: city,
      ),
    ).called(1);
  });
}
