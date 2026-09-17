import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growth_flutter_fase_05_riverpood/core/async/async_operation_guard.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/login/login_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/login/states/login_error_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/login/states/login_initial_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/login/states/login_loading_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/login/states/login_success_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/container.dart';

class LoginNotifier extends Notifier<LoginState> {
  final AsyncOperationGuard _operationGuard = AsyncOperationGuard();

  @override
  LoginState build() {
    ref.onDispose(_operationGuard.cancel);
    return const LoginInitialState();
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    if (state is LoginLoadingState) return;

    final operationId = _operationGuard.start();
    state = const LoginLoadingState();
    final loginUseCase = ref.read(loginUseCaseProvider);
    final result = await loginUseCase(
      email: email,
      password: password,
    );
    if (!_operationGuard.isCurrent(operationId)) return;

    state = switch (result) {
      Success() => const LoginSuccessState(),
      Failure(failure: final appFailure) => LoginErrorState(appFailure),
    };
  }
}
