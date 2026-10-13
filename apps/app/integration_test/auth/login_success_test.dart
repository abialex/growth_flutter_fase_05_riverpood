import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:growth_flutter_fase_05_riverpood/main.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/container.dart';
import 'package:integration_test/integration_test.dart';

import '../support/fake_repositories.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('logs in and opens the events list', (tester) async {
    final authRepository = FakeAuthRepository();
    final event = buildSampleEvent();
    addTearDown(authRepository.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(authRepository),
          eventsRepositoryProvider.overrideWithValue(
            FakeEventsRepository([event]),
          ),
          reservationsRepositoryProvider.overrideWithValue(
            FakeReservationsRepository(event: event),
          ),
        ],
        child: const MainApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Iniciar sesión'), findsOneWidget);

    final emailField = find.byWidgetPredicate(
      (widget) =>
          widget is TextField &&
          widget.keyboardType == TextInputType.emailAddress,
    );
    final passwordField = find.byWidgetPredicate(
      (widget) => widget is TextField && widget.obscureText,
    );
    await tester.enterText(emailField, 'usuario@example.com');
    await tester.enterText(passwordField, 'clave-segura');
    await tester.tap(find.text('Ingresar'));
    await tester.pump();

    expect(find.text('Iniciando sesión...'), findsOneWidget);
    await authRepository.finishSignIn();
    await tester.pumpAndSettle();

    expect(authRepository.lastEmail, 'usuario@example.com');
    expect(authRepository.lastPassword, 'clave-segura');
    expect(find.text('Eventos'), findsOneWidget);
    expect(find.text(event.name), findsOneWidget);
  });
}
