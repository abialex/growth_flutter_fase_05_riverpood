import 'dart:async';

import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/register/states/register_error_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/register/states/register_loading_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/register/states/register_success_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/auth_providers.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _ciudadController = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _ciudadController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    final ciudad = _ciudadController.text.trim();
    unawaited(
      ref
          .read(registerNotifierProvider.notifier)
          .register(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            nombre: _nombreController.text.trim(),
            ciudad: ciudad.isEmpty ? null : ciudad,
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
            child: AppCard(
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
                  AppTextField(
                    controller: _nombreController,
                    label: 'Nombre',
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: AppSpacing.md),
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
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    controller: _ciudadController,
                    label: 'Ciudad (opcional)',
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (isLoading)
                    const Center(child: AppLoader())
                  else
                    AppButton(label: 'Registrarme', onPressed: _onSubmit),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
