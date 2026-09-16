import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/auth_status.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  AuthService(this._supabaseClient);

  final SupabaseClient _supabaseClient;

  Future<Result<void, AppFailure>> signUp({
    required String email,
    required String password,
    required String nombre,
    String? ciudad,
  }) {
    return _run(() async {
      await _supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {
          'nombre': nombre,
          'ciudad': ?ciudad,
        },
      );
    });
  }

  Future<Result<void, AppFailure>> signIn({
    required String email,
    required String password,
  }) {
    return _run(() async {
      await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
    });
  }

  Future<Result<void, AppFailure>> signOut() {
    return _run(() => _supabaseClient.auth.signOut());
  }

  bool get isAuthenticated => _supabaseClient.auth.currentSession != null;

  Stream<AuthStatus> get authStatusChanges =>
      _supabaseClient.auth.onAuthStateChange.map(
        (authState) => authState.session == null
            ? AuthStatus.unauthenticated
            : AuthStatus.authenticated,
      );

  Future<Result<void, AppFailure>> _run(
    Future<void> Function() action,
  ) async {
    try {
      await action();
      return const Success(null);
    } on AuthException catch (exception) {
      return Failure(AppFailure.fromAuthException(exception));
    } on Object catch (exception) {
      return Failure(AppFailure.unknown(exception));
    }
  }
}
