import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growth_flutter_fase_05_riverpood/core/async/async_operation_guard.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/register/register_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/register/states/register_error_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/register/states/register_initial_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/register/states/register_loading_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/register/states/register_success_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/container.dart';

class RegisterNotifier extends Notifier<RegisterState> {
  final AsyncOperationGuard _operationGuard = AsyncOperationGuard();

  @override
  RegisterState build() {
    ref.onDispose(_operationGuard.cancel);
    return const RegisterInitialState();
  }

  Future<void> register({
    required String email,
    required String password,
    required String nombre,
    String? ciudad,
  }) async {
    if (state is RegisterLoadingState) return;

    final operationId = _operationGuard.start();
    state = const RegisterLoadingState();
    final registerUseCase = ref.read(registerUseCaseProvider);
    final result = await registerUseCase(
      email: email,
      password: password,
      nombre: nombre,
      ciudad: ciudad,
    );
    if (!_operationGuard.isCurrent(operationId)) return;

    state = switch (result) {
      Success() => const RegisterSuccessState(),
      Failure(failure: final appFailure) => RegisterErrorState(appFailure),
    };
  }
}
