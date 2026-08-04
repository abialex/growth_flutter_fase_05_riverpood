import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/errors/app_failure.dart';
import '../../core/result/result.dart';

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
          if (ciudad != null) 'ciudad': ciudad,
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

  Session? get currentSession => _supabaseClient.auth.currentSession;

  Stream<AuthState> get authStateChanges =>
      _supabaseClient.auth.onAuthStateChange;

  Future<Result<void, AppFailure>> _run(
    Future<void> Function() action,
  ) async {
    try {
      await action();
      return const Success(null);
    } on AuthException catch (exception) {
      return Failure(AppFailure.fromAuthException(exception));
    } catch (exception) {
      return Failure(AppFailure.unknown(exception));
    }
  }
}
