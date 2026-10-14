import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:growth_flutter_fase_05_riverpood/main.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/container.dart';
import 'package:integration_test/integration_test.dart';

import '../support/fake_repositories.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('logs out and redirects to login', (tester) async {
    final authRepository = FakeAuthRepository(isAuthenticated: true);
    final event = buildSampleEvent();
    final reservationsRepository = FakeReservationsRepository(event: event);
    addTearDown(authRepository.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(authRepository),
          eventsRepositoryProvider.overrideWithValue(
            FakeEventsRepository([event]),
          ),
          reservationsRepositoryProvider.overrideWithValue(
            reservationsRepository,
          ),
        ],
        child: const MainApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Eventos'), findsOneWidget);
    expect(find.text(event.name), findsOneWidget);

    await tester.tap(find.byTooltip('Cerrar sesión'));
    await tester.pumpAndSettle();

    expect(authRepository.signOutCalls, 1);
    expect(authRepository.isAuthenticated, isFalse);
    expect(find.text('Iniciar sesión'), findsOneWidget);
    expect(find.text('Eventos'), findsNothing);
  });
}
