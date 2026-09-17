import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/auth_repository.dart';

/// Authenticates a user with email and password.
final class LoginUseCase {
  /// Creates a use case with the authentication repository.
  const LoginUseCase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final AuthRepository _authRepository;

  /// Authenticates the user.
  Future<Result<void, AppFailure>> call({
    required String email,
    required String password,
  }) {
    return _authRepository.signIn(email: email, password: password);
  }
}
