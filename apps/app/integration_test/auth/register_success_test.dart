import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:growth_flutter_fase_05_riverpood/main.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/container.dart';
import 'package:integration_test/integration_test.dart';

import '../support/fake_repositories.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('registers an account and returns to login', (tester) async {
    final authRepository = FakeAuthRepository();
    addTearDown(authRepository.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [authRepositoryProvider.overrideWithValue(authRepository)],
        child: const MainApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Iniciar sesión'), findsOneWidget);
    await tester.tap(find.text('¿No tienes cuenta? Regístrate'));
    await tester.pumpAndSettle();

    expect(find.text('Crear cuenta'), findsOneWidget);
    final fields = find.byType(TextField);
    expect(fields, findsNWidgets(4));
    await tester.enterText(fields.at(0), 'Lucía Pérez');
    await tester.enterText(fields.at(1), 'lucia@example.com');
    await tester.enterText(fields.at(2), 'secure123');
    await tester.enterText(fields.at(3), 'Lima');

    await tester.tap(find.text('Registrarme'));
    await tester.pump();
    expect(find.text('Creando tu cuenta...'), findsOneWidget);

    await authRepository.finishSignUp();
    await tester.pump();

    expect(authRepository.lastSignUpName, 'Lucía Pérez');
    expect(authRepository.lastSignUpEmail, 'lucia@example.com');
    expect(authRepository.lastSignUpPassword, 'secure123');
    expect(authRepository.lastSignUpCity, 'Lima');
    expect(find.text('Registro exitoso'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.text('Iniciar sesión'), findsOneWidget);
  });
}
