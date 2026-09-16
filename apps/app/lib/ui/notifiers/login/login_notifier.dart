import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/login/login_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/login/states/login_error_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/login/states/login_initial_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/login/states/login_loading_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/login/states/login_success_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/auth_repository_providers.dart';

class LoginNotifier extends Notifier<LoginState> {
  @override
  LoginState build() => const LoginInitialState();

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const LoginLoadingState();
    final authRepository = ref.read(authRepositoryProvider);
    final result = await authRepository.signIn(
      email: email,
      password: password,
    );
    state = switch (result) {
      Success() => const LoginSuccessState(),
      Failure(failure: final appFailure) => LoginErrorState(appFailure),
    };
  }
}
