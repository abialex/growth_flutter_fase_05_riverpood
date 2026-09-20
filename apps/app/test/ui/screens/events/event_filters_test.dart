import 'package:flutter_test/flutter_test.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/event.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/event_status.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/screens/events/event_filters.dart';

void main() {
  test('matches an event when all selected filters match', () {
    final event = Event(
      id: 'event-1',
      name: 'Lima Football Match',
      sport: 'football',
      date: DateTime(2026, 9, 19, 22, 40),
      time: '22:40',
      city: 'Lima',
      venue: 'Central Stadium',
      totalSlots: 20,
      availableSlots: 10,
      status: EventStatus.open,
    );
    final filters = EventFilters(
      selectedSports: const ['football'],
      selectedCity: 'Lima',
      fromDate: DateTime(2026, 9, 19, 0, 10),
    );

    expect(filters.matches(event), isTrue);
  });

  test('matches an event when no filters are selected', () {
    final event = Event(
      id: 'event-1',
      name: 'Lima Football Match',
      sport: 'football',
      date: DateTime(2026, 9, 19, 22, 40),
      time: '22:40',
      city: 'Lima',
      venue: 'Central Stadium',
      totalSlots: 20,
      availableSlots: 10,
      status: EventStatus.open,
    );
    final filters = EventFilters();

    expect(filters.matches(event), isTrue);
  });

  test('removes the start date filter when the selected date is cleared', () {
    final event = Event(
      id: 'event-1',
      name: 'Lima Football Match',
      sport: 'football',
      date: DateTime(2026, 9, 18),
      time: '10:00',
      city: 'Lima',
      venue: 'Central Stadium',
      totalSlots: 20,
      availableSlots: 10,
      status: EventStatus.open,
    );
    final filters = EventFilters(fromDate: DateTime(2026, 9, 19));
    final clearedFilters = filters.selectFromDate(null);

    expect(filters.matches(event), isFalse);
    expect(clearedFilters.matches(event), isTrue);
  });

  test('matches an event on the selected date regardless of its time', () {
    final event = Event(
      id: 'event-1',
      name: 'Lima Football Match',
      sport: 'football',
      date: DateTime(2026, 1, 1, 0, 9),
      time: '00:09',
      city: 'Lima',
      venue: 'Central Stadium',
      totalSlots: 20,
      availableSlots: 10,
      status: EventStatus.open,
    );
    final filters = EventFilters(
      fromDate: DateTime(2026, 1, 1, 0, 10),
    );

    expect(filters.matches(event), isTrue);
  });

  test('matches an event after the selected start date', () {
    final event = Event(
      id: 'event-1',
      name: 'Lima Football Match',
      sport: 'football',
      date: DateTime(2026, 1, 2, 0, 1),
      time: '00:01',
      city: 'Lima',
      venue: 'Central Stadium',
      totalSlots: 20,
      availableSlots: 10,
      status: EventStatus.open,
    );
    final filters = EventFilters(
      fromDate: DateTime(2026, 1, 1, 23, 59),
    );

    expect(filters.matches(event), isTrue);
  });

  test('does not match an event when the selected city differs', () {
    final event = Event(
      id: 'event-1',
      name: 'Lima Football Match',
      sport: 'football',
      date: DateTime(2026, 9, 19),
      time: '10:00',
      city: 'Lima',
      venue: 'Central Stadium',
      totalSlots: 20,
      availableSlots: 10,
      status: EventStatus.open,
    );
    final filters = EventFilters(selectedCity: 'Cusco');

    expect(filters.matches(event), isFalse);
  });

  test('matches an event when its sport is one of the selected sports', () {
    final event = Event(
      id: 'event-1',
      name: 'Lima Football Match',
      sport: 'football',
      date: DateTime(2026, 9, 19),
      time: '10:00',
      city: 'Lima',
      venue: 'Central Stadium',
      totalSlots: 20,
      availableSlots: 10,
      status: EventStatus.open,
    );
    final filters = EventFilters(
      selectedSports: const ['basketball', 'football'],
    );

    expect(filters.matches(event), isTrue);
  });

  test('does not match an event when the selected sport differs', () {
    final event = Event(
      id: 'event-1',
      name: 'Lima Football Match',
      sport: 'football',
      date: DateTime(2026, 9, 19),
      time: '10:00',
      city: 'Lima',
      venue: 'Central Stadium',
      totalSlots: 20,
      availableSlots: 10,
      status: EventStatus.open,
    );
    final filters = EventFilters(selectedSports: const ['basketball']);

    expect(filters.matches(event), isFalse);
  });

  test('does not match an event before the selected start date', () {
    final event = Event(
      id: 'event-1',
      name: 'Lima Football Match',
      sport: 'football',
      date: DateTime(2026, 9, 18),
      time: '10:00',
      city: 'Lima',
      venue: 'Central Stadium',
      totalSlots: 20,
      availableSlots: 10,
      status: EventStatus.open,
    );
    final filters = EventFilters(fromDate: DateTime(2026, 9, 19));

    expect(filters.matches(event), isFalse);
  });
}
