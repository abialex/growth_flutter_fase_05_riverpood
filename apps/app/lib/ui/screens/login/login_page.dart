import 'dart:async';

import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/login/login_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/login/states/login_error_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/login/states/login_loading_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/login/states/login_success_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/auth_providers.dart';
import 'package:router_core/router_core.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    unawaited(
      ref
          .read(loginNotifierProvider.notifier)
          .login(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ),
    );
  }

  void _onNavigateToRegister() {
    unawaited(context.pushNamed('register'));
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<LoginState>(loginNotifierProvider, (previous, next) {
      if (next is LoginSuccessState) context.goNamed('eventos');
    });

    final loginState = ref.watch(loginNotifierProvider);
    final isLoading = loginState is LoginLoadingState;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: AppCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Iniciar sesión',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (loginState is LoginErrorState) ...[
                    AppBanner(
                      message: loginState.failure.message,
                      variant: AppBannerVariant.error,
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  if (loginState is LoginSuccessState) ...[
                    const AppBanner(
                      message: 'Sesión iniciada correctamente',
                      variant: AppBannerVariant.success,
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  AppTextField(
                    controller: _emailController,
                    label: 'Correo',
                    keyboardType: TextInputType.emailAddress,
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppPasswordField(
                    controller: _passwordController,
                    label: 'Contraseña',
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (isLoading)
                    const Center(child: AppLoader())
                  else
                    AppButton(label: 'Ingresar', onPressed: _onSubmit),
                  const SizedBox(height: AppSpacing.md),
                  TextButton(
                    onPressed: isLoading ? null : _onNavigateToRegister,
                    child: const Text('¿No tienes cuenta? Regístrate'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
