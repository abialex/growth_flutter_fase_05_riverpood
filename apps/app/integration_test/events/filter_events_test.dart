import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/event.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/event_status.dart';
import 'package:growth_flutter_fase_05_riverpood/main.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/container.dart';
import 'package:integration_test/integration_test.dart';

import '../support/fake_repositories.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('filters the events list by sport before opening a result', (
    tester,
  ) async {
    final authRepository = FakeAuthRepository(isAuthenticated: true);
    final volleyballEvent = _buildEvent(
      id: 'volleyball-event',
      name: 'Copa de vóley',
      sport: 'Vóley',
    );
    final footballEvent = _buildEvent(
      id: 'football-event',
      name: 'Copa de fútbol',
      sport: 'Fútbol',
    );
    addTearDown(authRepository.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(authRepository),
          eventsRepositoryProvider.overrideWithValue(
            FakeEventsRepository([volleyballEvent, footballEvent]),
          ),
          reservationsRepositoryProvider.overrideWithValue(
            FakeReservationsRepository(event: volleyballEvent),
          ),
        ],
        child: const MainApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(volleyballEvent.name), findsOneWidget);
    expect(find.text(footballEvent.name), findsOneWidget);

    await tester.tap(find.text('Vóley').first);
    await tester.pumpAndSettle();

    expect(find.text(volleyballEvent.name), findsOneWidget);
    expect(find.text(footballEvent.name), findsNothing);

    await tester.tap(find.text(volleyballEvent.name));
    await tester.pumpAndSettle();

    expect(find.text('Detalle del evento'), findsOneWidget);
    expect(find.text(volleyballEvent.name), findsOneWidget);
    expect(find.text('Reservar cupo'), findsOneWidget);
  });
}

Event _buildEvent({
  required String id,
  required String name,
  required String sport,
}) {
  return Event(
    id: id,
    name: name,
    sport: sport,
    date: DateTime(2026, 11, 15),
    time: '19:30:00',
    city: 'Lima',
    venue: 'Gimnasio Central',
    totalSlots: 20,
    availableSlots: 8,
    status: EventStatus.open,
  );
}
