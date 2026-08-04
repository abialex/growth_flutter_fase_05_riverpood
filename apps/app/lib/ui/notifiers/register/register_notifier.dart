import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/result/result.dart';
import '../../providers/auth_providers.dart';
import 'register_state.dart';
import 'states/register_error_state.dart';
import 'states/register_initial_state.dart';
import 'states/register_loading_state.dart';
import 'states/register_success_state.dart';

class RegisterNotifier extends Notifier<RegisterState> {
  @override
  RegisterState build() => const RegisterInitialState();

  Future<void> register({
    required String email,
    required String password,
    required String nombre,
    String? ciudad,
  }) async {
    state = const RegisterLoadingState();
    final authRepository = ref.read(authRepositoryProvider);
    final result = await authRepository.signUp(
      email: email,
      password: password,
      nombre: nombre,
      ciudad: ciudad,
    );
    state = switch (result) {
      Success() => const RegisterSuccessState(),
      Failure(failure: final appFailure) => RegisterErrorState(appFailure),
    };
  }
}
