import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/events/events_notifier.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/events/events_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/events/states/events_initial_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/container.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/screens/events/events_page.dart';

void main() {
  testWidgets('renders the events page while events are loading', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          eventsNotifierProvider.overrideWith(
            _EventsPageTestNotifier.new,
          ),
        ],
        child: const MaterialApp(home: EventsPage()),
      ),
    );
    await tester.pump();

    expect(find.text('Eventos'), findsOneWidget);
    expect(find.text('Cargando eventos...'), findsOneWidget);
    expect(find.byTooltip('Mis reservas'), findsOneWidget);
    expect(find.byTooltip('Cerrar sesión'), findsOneWidget);
  });
}

final class _EventsPageTestNotifier extends EventsNotifier {
  @override
  EventsState build() => const EventsInitialState();

  @override
  Future<void> loadEvents() async {}
}
