import 'package:flutter_test/flutter_test.dart';
import 'package:growth_flutter_fase_05_riverpood/core/enums/app_failure_type.dart';
import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/auth_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/login_use_case.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/logout_use_case.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/register_use_case.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  test('forwards credentials to sign in and preserves its failure', () async {
    const failure = AppFailure(
      failureType: AppFailureType.unauthorized,
      message: 'Invalid login credentials',
    );
    final repository = _MockAuthRepository();
    when(
      () => repository.signIn(
        email: 'person@example.com',
        password: 'incorrect-password',
      ),
    ).thenAnswer((_) async => const Failure<void, AppFailure>(failure));
    final useCase = LoginUseCase(authRepository: repository);

    final result = await useCase(
      email: 'person@example.com',
      password: 'incorrect-password',
    );

    expect(result, isA<Failure<void, AppFailure>>());
    expect((result as Failure<void, AppFailure>).failure, same(failure));
    verify(
      () => repository.signIn(
        email: 'person@example.com',
        password: 'incorrect-password',
      ),
    ).called(1);
  });

  test('forwards registration profile including its optional city', () async {
    final repository = _MockAuthRepository();
    when(
      () => repository.signUp(
        email: 'person@example.com',
        password: 'safe-password',
        name: 'New Person',
        city: 'Lima',
      ),
    ).thenAnswer((_) async => const Success<void, AppFailure>(null));
    final useCase = RegisterUseCase(authRepository: repository);

    final result = await useCase(
      email: 'person@example.com',
      password: 'safe-password',
      name: 'New Person',
      city: 'Lima',
    );

    expect(result, isA<Success<void, AppFailure>>());
    verify(
      () => repository.signUp(
        email: 'person@example.com',
        password: 'safe-password',
        name: 'New Person',
        city: 'Lima',
      ),
    ).called(1);
  });

  test('uses a null city when registration omits the optional field', () async {
    final repository = _MockAuthRepository();
    when(
      () => repository.signUp(
        email: 'person@example.com',
        password: 'safe-password',
        name: 'New Person',
      ),
    ).thenAnswer((_) async => const Success<void, AppFailure>(null));
    final useCase = RegisterUseCase(authRepository: repository);

    await useCase(
      email: 'person@example.com',
      password: 'safe-password',
      name: 'New Person',
    );

    verify(
      () => repository.signUp(
        email: 'person@example.com',
        password: 'safe-password',
        name: 'New Person',
      ),
    ).called(1);
  });

  test('forwards logout and preserves a repository failure', () async {
    const failure = AppFailure(
      failureType: AppFailureType.network,
      message: 'Network unavailable',
    );
    final repository = _MockAuthRepository();
    when(
      repository.signOut,
    ).thenAnswer((_) async => const Failure<void, AppFailure>(failure));
    final useCase = LogoutUseCase(authRepository: repository);

    final result = await useCase();

    expect(result, isA<Failure<void, AppFailure>>());
    expect((result as Failure<void, AppFailure>).failure, same(failure));
    verify(repository.signOut).called(1);
  });
}
