import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/login/login_state.dart';

class LoginErrorState extends LoginState {
  const LoginErrorState(this.failure);

  final AppFailure failure;
}
