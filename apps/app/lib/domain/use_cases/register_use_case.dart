import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/auth_repository.dart';

/// Registers a new user account.
final class RegisterUseCase {
  /// Creates a use case with the authentication repository.
  const RegisterUseCase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final AuthRepository _authRepository;

  /// Registers a user with the supplied profile data.
  Future<Result<void, AppFailure>> call({
    required String email,
    required String password,
    required String nombre,
    String? ciudad,
  }) {
    return _authRepository.signUp(
      email: email,
      password: password,
      nombre: nombre,
      ciudad: ciudad,
    );
  }
}
