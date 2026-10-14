import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:growth_flutter_fase_05_riverpood/main.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/container.dart';
import 'package:integration_test/integration_test.dart';

import '../support/fake_repositories.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'keeps the reservation pending after a purchase failure and retries',
    (tester) async {
      final authRepository = FakeAuthRepository(isAuthenticated: true);
      final event = buildSampleEvent();
      final reservationsRepository = FakeReservationsRepository(event: event)
        ..seedPendingReservation(reservationId: 'reservation-1', seatCount: 1);
      final purchaseRepository = FakePurchaseRepository(
        reservationsRepository: reservationsRepository,
        failFirstAttempt: true,
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

      await tester.tap(find.byTooltip('Mis reservas'));
      await tester.pumpAndSettle();

      expect(find.text('Mis reservas'), findsOneWidget);
      expect(find.text(event.name), findsOneWidget);
      expect(find.text('pendiente'), findsOneWidget);

      await tester.tap(find.text('Confirmar compra'));
      await tester.pumpAndSettle();

      expect(
        find.text('No se pudo confirmar la compra. Inténtalo nuevamente.'),
        findsOneWidget,
      );
      expect(find.text('pendiente'), findsOneWidget);
      expect(find.text('Código de ticket: TICKET-TEST-001'), findsNothing);
      expect(find.text('Confirmar compra'), findsOneWidget);
      expect(purchaseRepository.confirmCalls, 1);

      await tester.tap(find.text('Confirmar compra'));
      await tester.pump();
      expect(find.text('Confirmando compra...'), findsOneWidget);

      await purchaseRepository.finishConfirmPurchase();
      await tester.pumpAndSettle();

      expect(purchaseRepository.confirmCalls, 2);
      expect(purchaseRepository.lastReservationId, 'reservation-1');
      expect(find.text('confirmada'), findsOneWidget);
      expect(find.text('Código de ticket: TICKET-TEST-001'), findsOneWidget);
      expect(find.text('Confirmar compra'), findsNothing);
    },
  );
}
