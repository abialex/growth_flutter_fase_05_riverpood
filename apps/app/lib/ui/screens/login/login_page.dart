import 'dart:async';

import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/layout/app_layout_tokens.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/login/states/login_error_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/login/states/login_loading_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/login/states/login_success_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/container.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/routing/app_route.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/widgets/app_validated_field.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/widgets/theme_mode_button.dart';
import 'package:router_core/router_core.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    unawaited(
      ref
          .read(loginNotifierProvider.notifier)
          .onLogin(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ),
    );
  }

  void _onNavigateToRegister() {
    unawaited(context.pushNamed(AppRoute.register.routeName));
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginNotifierProvider);
    final isLoading = loginState is LoginLoadingState;

    return Scaffold(
      appBar: AppBar(
        actions: const [
          ThemeModeButton(heroTag: 'theme-mode-toggle'),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppLayoutTokens.formMaxWidth,
                ),
                child: AppCard(
                  child: AutofillGroup(
                    child: Form(
                      key: _formKey,
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
                          AppValidatedField(
                            controller: _emailController,
                            label: 'Correo',
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [
                              AutofillHints.username,
                              AutofillHints.email,
                            ],
                            validator: AppValidators.compose([
                              AppValidators.requiredField(
                                message: 'Ingresa tu correo.',
                              ),
                              AppValidators.email(),
                            ]),
                            enabled: !isLoading,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          AppValidatedField(
                            controller: _passwordController,
                            label: 'Contraseña',
                            obscureText: true,
                            textInputAction: TextInputAction.done,
                            autofillHints: const [AutofillHints.password],
                            validator: AppValidators.password(
                              emptyMessage: 'Ingresa tu contraseña.',
                              minLengthMessage: 'Usa al menos 6 caracteres.',
                            ),
                            enabled: !isLoading,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          if (isLoading)
                            const Center(
                              child: AppLoader(message: 'Iniciando sesión...'),
                            )
                          else
                            AppButton(label: 'Ingresar', onPressed: _onSubmit),
                          const SizedBox(height: AppSpacing.md),
                          Center(
                            child: AppButton(
                              label: '¿No tienes cuenta? Regístrate',
                              emphasis: AppEmphasis.outline,
                              size: AppButtonSize.small,
                              onPressed: isLoading
                                  ? null
                                  : _onNavigateToRegister,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
