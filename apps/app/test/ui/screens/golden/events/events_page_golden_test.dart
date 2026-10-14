import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/event.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/event_reservation_status.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/event_status.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/events/events_notifier.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/events/events_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/events/states/events_loaded_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/container.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/screens/events/events_page.dart';

void main() {
  testWidgets('matches the loaded events page golden', (tester) async {
    _configureGoldenSurface(tester);
    await _loadMaterialIconsFont();
    final events = [
      _createEvent('event-1', 'Torneo de vóley'),
      _createEvent('event-2', 'Otro evento'),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          eventsNotifierProvider.overrideWith(
            () => _EventsPageGoldenTestNotifier(events),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const EventsPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('events_page.png'),
    );
  });
}

void _configureGoldenSurface(WidgetTester tester) {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Future<void> _loadMaterialIconsFont() async {
  final fontLoader = FontLoader('MaterialIcons')
    ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
  await fontLoader.load();
}

Event _createEvent(String id, String name) {
  return Event(
    id: id,
    name: name,
    sport: 'Vóley',
    date: DateTime(2026, 11, 15),
    time: '19:30:00',
    city: 'Lima',
    venue: 'Gimnasio Central',
    totalSlots: 20,
    availableSlots: 8,
    status: EventStatus.open,
  );
}

final class _EventsPageGoldenTestNotifier extends EventsNotifier {
  _EventsPageGoldenTestNotifier(this.events);

  final List<Event> events;

  @override
  EventsState build() {
    return EventsLoadedState(
      events,
      filteredEvents: events,
      eventReservationStatuses: {
        events[0].id: EventReservationStatus.purchased,
        events[1].id: EventReservationStatus.reserved,
      },
    );
  }

  @override
  Future<void> loadEvents() async {}
}
