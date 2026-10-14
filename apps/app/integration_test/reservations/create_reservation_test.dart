import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:growth_flutter_fase_05_riverpood/main.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/container.dart';
import 'package:integration_test/integration_test.dart';

import '../support/fake_repositories.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'creates a reservation, confirms its purchase, and shows a ticket',
    (tester) async {
      final authRepository = FakeAuthRepository(isAuthenticated: true);
      final event = buildSampleEvent();
      final reservationsRepository = FakeReservationsRepository(event: event);
      final purchaseRepository = FakePurchaseRepository(
        reservationsRepository: reservationsRepository,
      );
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
            purchaseRepositoryProvider.overrideWithValue(purchaseRepository),
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

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(find.text('Eventos'), findsOneWidget);

      await tester.tap(find.byTooltip('Mis reservas'));
      await tester.pumpAndSettle();

      expect(find.text('Mis reservas'), findsOneWidget);
      expect(find.text(event.name), findsOneWidget);
      expect(find.text('pendiente'), findsOneWidget);
      expect(find.text('Cupos reservados: 1'), findsOneWidget);

      await tester.tap(find.text('Confirmar compra'));
      await tester.pump();
      expect(find.text('Confirmando compra...'), findsOneWidget);

      await purchaseRepository.finishConfirmPurchase();
      await tester.pumpAndSettle();

      expect(purchaseRepository.lastReservationId, 'reservation-1');
      expect(find.text('confirmada'), findsOneWidget);
      expect(find.text('Código de ticket: TICKET-TEST-001'), findsOneWidget);
      expect(find.text('Confirmar compra'), findsNothing);
    },
  );
}
