import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:growth_flutter_fase_05_riverpood/main.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/container.dart';
import 'package:integration_test/integration_test.dart';

import '../support/fake_repositories.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('opens the selected event details from the events list', (
    tester,
  ) async {
    final authRepository = FakeAuthRepository(isAuthenticated: true);
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

    expect(find.text('Eventos'), findsOneWidget);
    expect(find.text(event.name), findsOneWidget);

    await tester.tap(find.text(event.name));
    await tester.pumpAndSettle();

    expect(find.text('Detalle del evento'), findsOneWidget);
    expect(find.text(event.name), findsOneWidget);
    expect(find.text('${event.venue}, ${event.city}'), findsOneWidget);
    expect(find.text('Reservar cupo'), findsOneWidget);
  });
}
