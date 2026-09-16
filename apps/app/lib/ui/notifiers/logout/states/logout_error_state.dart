import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/logout/logout_state.dart';

/// Indicates that the logout request failed.
class LogoutErrorState extends LogoutState {
  /// Creates an error state with the failure that occurred.
  const LogoutErrorState(this.failure);

  /// The failure returned by the logout operation.
  final AppFailure failure;
}
