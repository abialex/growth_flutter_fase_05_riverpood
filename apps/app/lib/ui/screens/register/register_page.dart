import 'dart:async';

import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:growth_flutter_fase_05_riverpood/ui/layout/app_layout_tokens.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/register/states/register_error_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/register/states/register_loading_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/register/states/register_success_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/container.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/widgets/app_validated_field.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _cityController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final city = _cityController.text.trim();
    unawaited(
      ref
          .read(registerNotifierProvider.notifier)
          .onRegister(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            name: _nameController.text.trim(),
            city: city.isEmpty ? null : city,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final registerState = ref.watch(registerNotifierProvider);
    final isLoading = registerState is RegisterLoadingState;

    return Scaffold(
      appBar: AppBar(title: const Text('Crear cuenta')),
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
                          if (registerState is RegisterErrorState) ...[
                            AppBanner(
                              message: registerState.failure.message,
                              variant: AppBannerVariant.error,
                            ),
                            const SizedBox(height: AppSpacing.md),
                          ],
                          if (registerState is RegisterSuccessState) ...[
                            const AppBanner(
                              message: 'Registro exitoso',
                              variant: AppBannerVariant.success,
                            ),
                            const SizedBox(height: AppSpacing.md),
                          ],
                          AppValidatedField(
                            controller: _nameController,
                            label: 'Nombre',
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.name],
                            validator: AppValidators.compose([
                              AppValidators.requiredField(
                                message: 'Ingresa tu nombre.',
                              ),
                              AppValidators.minLength(
                                minLength: 2,
                                message: 'Ingresa un nombre válido.',
                              ),
                            ]),
                            enabled: !isLoading,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          AppValidatedField(
                            controller: _emailController,
                            label: 'Correo',
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.email],
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
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.newPassword],
                            validator: AppValidators.password(
                              emptyMessage: 'Ingresa tu contraseña.',
                              minLengthMessage: 'Usa al menos 6 caracteres.',
                            ),
                            enabled: !isLoading,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          AppTextField(
                            controller: _cityController,
                            label: 'Ciudad (opcional)',
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            autofillHints: const [AutofillHints.addressCity],
                            enabled: !isLoading,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          if (isLoading)
                            const Center(
                              child: AppLoader(message: 'Creando tu cuenta...'),
                            )
                          else
                            AppButton(
                              label: 'Registrarme',
                              onPressed: _onSubmit,
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
