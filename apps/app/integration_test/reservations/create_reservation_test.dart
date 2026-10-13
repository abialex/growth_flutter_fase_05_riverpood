import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:growth_flutter_fase_05_riverpood/main.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/container.dart';
import 'package:integration_test/integration_test.dart';

import '../support/fake_repositories.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('creates one reservation and updates the event detail', (
    tester,
  ) async {
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

    await tester.tap(find.text(event.name));
    await tester.pumpAndSettle();
    expect(find.text('Reservar cupo'), findsOneWidget);

    await tester.tap(find.text('Reservar cupo'));
    await tester.pump();
    expect(find.text('Procesando reserva...'), findsOneWidget);

    await reservationsRepository.finishCreateReservation();
    await tester.pumpAndSettle();

    expect(find.text('Reserva creada correctamente'), findsOneWidget);
    expect(
      find.text('Ya tienes una reserva para este evento.'),
      findsOneWidget,
    );
    expect(reservationsRepository.lastEventId, event.id);
    expect(reservationsRepository.lastSeatCount, 1);
  });
}
