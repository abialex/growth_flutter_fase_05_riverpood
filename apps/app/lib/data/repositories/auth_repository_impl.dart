import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/errors/app_failure.dart';
import '../../core/result/result.dart';
import '../../domain/repositories/auth_repository.dart';
import '../services/auth_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._authService);

  final AuthService _authService;

  @override
  Future<Result<void, AppFailure>> signUp({
    required String email,
    required String password,
    required String nombre,
    String? ciudad,
  }) {
    return _authService.signUp(
      email: email,
      password: password,
      nombre: nombre,
      ciudad: ciudad,
    );
  }

  @override
  Future<Result<void, AppFailure>> signIn({
    required String email,
    required String password,
  }) {
    return _authService.signIn(email: email, password: password);
  }

  @override
  Future<Result<void, AppFailure>> signOut() {
    return _authService.signOut();
  }

  @override
  Session? get currentSession => _authService.currentSession;

  @override
  Stream<AuthState> get authStateChanges => _authService.authStateChanges;
}
