import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/data/services/auth_service.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/auth_status.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._authService);

  final AuthService _authService;

  @override
  Future<Result<void, AppFailure>> signUp({
    required String email,
    required String password,
    required String name,
    String? city,
  }) {
    return _authService.signUp(
      email: email,
      password: password,
      name: name,
      city: city,
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
  bool get isAuthenticated => _authService.isAuthenticated;

  @override
  Stream<AuthStatus> get authStatusChanges => _authService.authStatusChanges;
}
