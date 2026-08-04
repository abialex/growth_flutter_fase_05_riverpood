import '../../../../core/errors/app_failure.dart';
import '../login_state.dart';

class LoginErrorState extends LoginState {
  const LoginErrorState(this.failure);

  final AppFailure failure;
}
