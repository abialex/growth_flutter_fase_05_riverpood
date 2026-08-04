import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/result/result.dart';
import '../../providers/auth_providers.dart';
import 'login_state.dart';
import 'states/login_error_state.dart';
import 'states/login_initial_state.dart';
import 'states/login_loading_state.dart';
import 'states/login_success_state.dart';

class LoginNotifier extends Notifier<LoginState> {
  @override
  LoginState build() => const LoginInitialState();

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const LoginLoadingState();
    final authRepository = ref.read(authRepositoryProvider);
    final result = await authRepository.signIn(email: email, password: password);
    state = switch (result) {
      Success() => const LoginSuccessState(),
      Failure(failure: final appFailure) => LoginErrorState(appFailure),
    };
  }
}
