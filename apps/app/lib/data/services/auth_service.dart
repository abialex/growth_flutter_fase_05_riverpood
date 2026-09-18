import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/errors/failure_mapper.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/core/supabase/supabase_logger.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/auth_status.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Performs authentication operations through Supabase.
class AuthService {
  /// Creates an authentication service with its external dependencies.
  AuthService(
    SupabaseClient supabaseClient,
    SupabaseLogger logger,
    FailureMapper failureMapper,
  ) : _supabaseClient = supabaseClient,
      _logger = logger,
      _failureMapper = failureMapper;

  final SupabaseClient _supabaseClient;
  final SupabaseLogger _logger;
  final FailureMapper _failureMapper;

  /// Creates a user account.
  Future<Result<void, AppFailure>> signUp({
    required String email,
    required String password,
    required String name,
    String? city,
  }) {
    return _run(
      operation: 'signUp',
      action: () async {
        final response = await _supabaseClient.auth.signUp(
          email: email,
          password: password,
          data: {
            'nombre': name,
            'ciudad': ?city,
          },
        );

        // Close the automatic session so login remains an explicit action.
        if (response.session != null) {
          await _supabaseClient.auth.signOut();
        }
      },
    );
  }

  /// Signs in a user with email and password.
  Future<Result<void, AppFailure>> signIn({
    required String email,
    required String password,
  }) {
    return _run(
      operation: 'signIn',
      action: () async {
        await _supabaseClient.auth.signInWithPassword(
          email: email,
          password: password,
        );
      },
    );
  }

  /// Signs out the current user.
  Future<Result<void, AppFailure>> signOut() {
    return _run(
      operation: 'signOut',
      action: () => _supabaseClient.auth.signOut(),
    );
  }

  /// Whether an authenticated session is available.
  bool get isAuthenticated => _supabaseClient.auth.currentSession != null;

  /// Emits authentication status changes.
  Stream<AuthStatus> get authStatusChanges =>
      _supabaseClient.auth.onAuthStateChange.map(
        (authState) => authState.session == null
            ? AuthStatus.unauthenticated
            : AuthStatus.authenticated,
      );

  Future<Result<void, AppFailure>> _run({
    required String operation,
    required Future<void> Function() action,
  }) async {
    try {
      await action();
      return const Success(null);
    } on AuthException catch (exception, stackTrace) {
      _logger.logAuthError(
        operation: operation,
        exception: exception,
        stackTrace: stackTrace,
      );
      return Failure(_failureMapper.map(exception));
    } on Object catch (exception, stackTrace) {
      _logger.logUnexpectedError(
        operation: operation,
        error: exception,
        stackTrace: stackTrace,
      );
      return Failure(_failureMapper.map(exception));
    }
  }
}
