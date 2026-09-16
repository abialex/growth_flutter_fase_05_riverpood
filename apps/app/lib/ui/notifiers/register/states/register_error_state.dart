import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/register/register_state.dart';

class RegisterErrorState extends RegisterState {
  const RegisterErrorState(this.failure);

  final AppFailure failure;
}
