import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/register/register_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/register/states/register_error_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/register/states/register_initial_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/register/states/register_loading_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/register/states/register_success_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/auth_providers.dart';

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
