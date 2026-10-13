import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:growth_flutter_fase_05_riverpood/core/enums/app_failure_type.dart';
import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/login/login_notifier.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/login/login_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/login/states/login_error_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/login/states/login_initial_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/login/states/login_loading_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/container.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/screens/login/login_page.dart';

void main() {
  testWidgets('shows the login content in its initial state', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          loginNotifierProvider.overrideWith(_LoginPageTestNotifier.new),
        ],
        child: const MaterialApp(home: LoginPage()),
      ),
    );

    expect(find.text('Iniciar sesión'), findsOneWidget);
    expect(find.text('Correo'), findsOneWidget);
    expect(find.text('Contraseña'), findsOneWidget);
    expect(find.text('Ingresar'), findsOneWidget);
    expect(find.text('¿No tienes cuenta? Regístrate'), findsOneWidget);
  });

  testWidgets('shows a loader after submitting valid credentials', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          loginNotifierProvider.overrideWith(_LoginPageLoadingTestNotifier.new),
        ],
        child: const MaterialApp(home: LoginPage()),
      ),
    );

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'user@example.com');
    await tester.enterText(fields.at(1), 'password123');
    await tester.tap(find.text('Ingresar'));
    await tester.pump();

    expect(find.text('Iniciando sesión...'), findsOneWidget);
    expect(find.text('Ingresar'), findsNothing);
  });

  testWidgets('shows required errors when submitting empty credentials', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          loginNotifierProvider.overrideWith(_LoginPageLoadingTestNotifier.new),
        ],
        child: const MaterialApp(home: LoginPage()),
      ),
    );

    await tester.tap(find.text('Ingresar'));
    await tester.pump();

    expect(find.text('Ingresa tu correo.'), findsOneWidget);
    expect(find.text('Ingresa tu contraseña.'), findsOneWidget);
    expect(find.text('Iniciando sesión...'), findsNothing);
    expect(find.text('Ingresar'), findsOneWidget);
  });

  testWidgets('shows an error when credentials are rejected', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          loginNotifierProvider.overrideWith(_LoginPageErrorTestNotifier.new),
        ],
        child: const MaterialApp(home: LoginPage()),
      ),
    );

    expect(
      find.text('El correo o la contraseña no son correctos.'),
      findsOneWidget,
    );
    expect(find.text('Ingresar'), findsOneWidget);
    expect(find.text('Iniciando sesión...'), findsNothing);
  });
}

final class _LoginPageTestNotifier extends LoginNotifier {
  @override
  LoginState build() => const LoginInitialState();
}

final class _LoginPageLoadingTestNotifier extends LoginNotifier {
  @override
  LoginState build() => const LoginInitialState();

  @override
  Future<void> onLogin({
    required String email,
    required String password,
  }) async {
    state = const LoginLoadingState();
  }
}

final class _LoginPageErrorTestNotifier extends LoginNotifier {
  @override
  LoginState build() => const LoginErrorState(
    AppFailure(
      failureType: AppFailureType.unauthorized,
      message: 'El correo o la contraseña no son correctos.',
    ),
  );
}
