import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/auth_status.dart';

/// Defines authentication operations required by the domain.
abstract class AuthRepository {
  /// Creates an account with the supplied profile data.
  Future<Result<void, AppFailure>> signUp({
    required String email,
    required String password,
    required String name,
    String? city,
  });

  /// Authenticates a user with email and password.
  Future<Result<void, AppFailure>> signIn({
    required String email,
    required String password,
  });

  /// Signs out the current user.
  Future<Result<void, AppFailure>> signOut();

  /// Whether an authenticated session is available.
  bool get isAuthenticated;

  /// Emits authentication status changes.
  Stream<AuthStatus> get authStatusChanges;
}
