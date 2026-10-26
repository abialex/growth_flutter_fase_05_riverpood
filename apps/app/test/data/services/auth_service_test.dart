import 'package:flutter_test/flutter_test.dart';
import 'package:growth_flutter_fase_05_riverpood/core/enums/app_failure_type.dart';
import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/errors/failure_mapper.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/core/supabase/supabase_logger.dart';
import 'package:growth_flutter_fase_05_riverpood/data/services/auth_service.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/auth_status.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _MockSupabaseClient extends Mock implements SupabaseClient {}

class _MockGoTrueClient extends Mock implements GoTrueClient {}

class _MockFailureMapper extends Mock implements FailureMapper {}

Session _testSession() => Session(
  accessToken: 'test-access-token',
  tokenType: 'bearer',
  user: const User(
    id: 'user-id',
    appMetadata: {},
    userMetadata: null,
    aud: 'authenticated',
    createdAt: '2026-01-01T00:00:00Z',
  ),
);

void main() {
  group('AuthService.signIn', () {
    late _MockSupabaseClient supabaseClient;
    late _MockGoTrueClient authClient;
    late _MockFailureMapper failureMapper;

    setUp(() {
      supabaseClient = _MockSupabaseClient();
      authClient = _MockGoTrueClient();
      failureMapper = _MockFailureMapper();

      when(() => supabaseClient.auth).thenReturn(authClient);
    });

    test('returns success when Supabase signs in the user', () async {
      when(
        () => authClient.signInWithPassword(
          email: 'person@example.com',
          password: 'secure-password',
        ),
      ).thenAnswer((_) async => AuthResponse());
      final service = AuthService(
        supabaseClient,
        const SupabaseLogger(),
        failureMapper,
      );

      final result = await service.signIn(
        email: 'person@example.com',
        password: 'secure-password',
      );

      expect(result, isA<Success<void, AppFailure>>());
      verify(
        () => authClient.signInWithPassword(
          email: 'person@example.com',
          password: 'secure-password',
        ),
      ).called(1);
    });

    test(
      'returns a mapped failure when Supabase rejects the sign-in',
      () async {
        const authException = AuthException('Invalid credentials');
        const expectedFailure = AppFailure(
          failureType: AppFailureType.unauthorized,
          message: 'El correo o la contraseña no son correctos.',
        );

        when(
          () => authClient.signInWithPassword(
            email: 'person@example.com',
            password: 'secure-password',
          ),
        ).thenAnswer((_) async => throw authException);
        when(
          () => failureMapper.map(authException),
        ).thenReturn(expectedFailure);

        final service = AuthService(
          supabaseClient,
          const SupabaseLogger(),
          failureMapper,
        );

        final result = await service.signIn(
          email: 'person@example.com',
          password: 'secure-password',
        );

        expect(
          result,
          isA<Failure<void, AppFailure>>().having(
            (failureResult) => failureResult.failure,
            'failure',
            same(expectedFailure),
          ),
        );
        verify(() => failureMapper.map(authException)).called(1);
      },
    );

    test('returns a mapped failure when sign-in fails unexpectedly', () async {
      final unexpectedError = Exception('Unexpected sign-in error');
      const expectedFailure = AppFailure(
        failureType: AppFailureType.unknown,
        message: 'No se pudo completar la operación. Inténtalo nuevamente.',
      );

      when(
        () => authClient.signInWithPassword(
          email: 'person@example.com',
          password: 'secure-password',
        ),
      ).thenAnswer((_) async => throw unexpectedError);
      when(
        () => failureMapper.map(unexpectedError),
      ).thenReturn(expectedFailure);

      final service = AuthService(
        supabaseClient,
        const SupabaseLogger(),
        failureMapper,
      );

      final result = await service.signIn(
        email: 'person@example.com',
        password: 'secure-password',
      );

      expect(
        result,
        isA<Failure<void, AppFailure>>().having(
          (failureResult) => failureResult.failure,
          'failure',
          same(expectedFailure),
        ),
      );
      verify(() => failureMapper.map(unexpectedError)).called(1);
    });
  });

  group('AuthService.signUp', () {
    late _MockSupabaseClient supabaseClient;
    late _MockGoTrueClient authClient;
    late _MockFailureMapper failureMapper;

    setUp(() {
      supabaseClient = _MockSupabaseClient();
      authClient = _MockGoTrueClient();
      failureMapper = _MockFailureMapper();

      when(() => supabaseClient.auth).thenReturn(authClient);
    });

    test('signs out the automatic session after registration', () async {
      final session = _testSession();

      when(
        () => authClient.signUp(
          email: 'person@example.com',
          password: 'secure-password',
          data: {'nombre': 'Ana', 'ciudad': 'Lima'},
        ),
      ).thenAnswer((_) async => AuthResponse(session: session));
      when(() => authClient.signOut()).thenAnswer((_) async {});

      final service = AuthService(
        supabaseClient,
        const SupabaseLogger(),
        failureMapper,
      );

      final result = await service.signUp(
        email: 'person@example.com',
        password: 'secure-password',
        name: 'Ana',
        city: 'Lima',
      );

      expect(result, isA<Success<void, AppFailure>>());
      verify(() => authClient.signOut()).called(1);
    });

    test('keeps registration successful when no session is returned', () async {
      when(
        () => authClient.signUp(
          email: 'person@example.com',
          password: 'secure-password',
          data: {'nombre': 'Ana'},
        ),
      ).thenAnswer((_) async => AuthResponse());

      final service = AuthService(
        supabaseClient,
        const SupabaseLogger(),
        failureMapper,
      );

      final result = await service.signUp(
        email: 'person@example.com',
        password: 'secure-password',
        name: 'Ana',
      );

      expect(result, isA<Success<void, AppFailure>>());
      verify(
        () => authClient.signUp(
          email: 'person@example.com',
          password: 'secure-password',
          data: {'nombre': 'Ana'},
        ),
      ).called(1);
      verifyNever(() => authClient.signOut());
    });
  });

  group('AuthService.signOut', () {
    late _MockSupabaseClient supabaseClient;
    late _MockGoTrueClient authClient;
    late _MockFailureMapper failureMapper;

    setUp(() {
      supabaseClient = _MockSupabaseClient();
      authClient = _MockGoTrueClient();
      failureMapper = _MockFailureMapper();

      when(() => supabaseClient.auth).thenReturn(authClient);
    });

    test('returns success after signing out', () async {
      when(() => authClient.signOut()).thenAnswer((_) async {});

      final service = AuthService(
        supabaseClient,
        const SupabaseLogger(),
        failureMapper,
      );

      final result = await service.signOut();

      expect(result, isA<Success<void, AppFailure>>());
      verify(() => authClient.signOut()).called(1);
    });
  });

  group('AuthService session state', () {
    late _MockSupabaseClient supabaseClient;
    late _MockGoTrueClient authClient;
    late _MockFailureMapper failureMapper;

    setUp(() {
      supabaseClient = _MockSupabaseClient();
      authClient = _MockGoTrueClient();
      failureMapper = _MockFailureMapper();

      when(() => supabaseClient.auth).thenReturn(authClient);
    });

    test('reports authenticated when a session exists', () {
      when(() => authClient.currentSession).thenReturn(_testSession());
      final service = AuthService(
        supabaseClient,
        const SupabaseLogger(),
        failureMapper,
      );

      expect(service.isAuthenticated, isTrue);
    });

    test('reports unauthenticated when no session exists', () {
      when(() => authClient.currentSession).thenReturn(null);
      final service = AuthService(
        supabaseClient,
        const SupabaseLogger(),
        failureMapper,
      );

      expect(service.isAuthenticated, isFalse);
    });

    test('maps session changes to authentication statuses', () async {
      when(() => authClient.onAuthStateChange).thenAnswer(
        (_) => Stream.fromIterable([
          AuthState(AuthChangeEvent.signedIn, _testSession()),
          const AuthState(AuthChangeEvent.signedOut, null),
        ]),
      );
      final service = AuthService(
        supabaseClient,
        const SupabaseLogger(),
        failureMapper,
      );

      final statuses = await service.authStatusChanges.toList();

      expect(
        statuses,
        [AuthStatus.authenticated, AuthStatus.unauthenticated],
      );
    });
  });
}
