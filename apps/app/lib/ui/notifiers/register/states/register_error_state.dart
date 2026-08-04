import '../../../../core/errors/app_failure.dart';
import '../register_state.dart';

class RegisterErrorState extends RegisterState {
  const RegisterErrorState(this.failure);

  final AppFailure failure;
}
