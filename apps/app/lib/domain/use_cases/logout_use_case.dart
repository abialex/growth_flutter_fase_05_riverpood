import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/auth_repository.dart';

/// Signs out the current user.
final class LogoutUseCase {
  /// Creates a use case with the authentication repository.
  const LogoutUseCase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final AuthRepository _authRepository;

  /// Signs out the current user.
  Future<Result<void, AppFailure>> call() {
    return _authRepository.signOut();
  }
}
