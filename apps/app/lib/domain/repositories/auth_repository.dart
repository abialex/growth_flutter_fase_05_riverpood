import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/errors/app_failure.dart';
import '../../core/result/result.dart';

abstract class AuthRepository {
  Future<Result<void, AppFailure>> signUp({
    required String email,
    required String password,
    required String nombre,
    String? ciudad,
  });

  Future<Result<void, AppFailure>> signIn({
    required String email,
    required String password,
  });

  Future<Result<void, AppFailure>> signOut();

  Session? get currentSession;

  Stream<AuthState> get authStateChanges;
}
