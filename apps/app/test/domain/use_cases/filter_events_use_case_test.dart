import 'package:flutter_test/flutter_test.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/event.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/event_filters.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/event_status.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/filter_events_use_case.dart';

void main() {
  const useCase = FilterEventsUseCase();

  test('returns matching events in their original order', () {
    final events = [
      _createEvent(id: 'event-1', city: 'Lima'),
      _createEvent(id: 'event-2', city: 'Cusco'),
      _createEvent(id: 'event-3', city: 'Lima'),
    ];

    final result = useCase(
      events: events,
      filters: EventFilters(selectedCity: 'Lima'),
    );

    expect(result.map((event) => event.id), ['event-1', 'event-3']);
    expect(events, hasLength(3));
  });

  test('returns every event when no filters are selected', () {
    final events = [
      _createEvent(id: 'event-1', city: 'Lima'),
      _createEvent(id: 'event-2', city: 'Cusco'),
    ];

    final result = useCase(events: events, filters: EventFilters());

    expect(result, events);
  });

  test('applies all active filters together', () {
    final events = [
      _createEvent(id: 'match', city: 'Lima'),
      _createEvent(id: 'wrong-city', city: 'Cusco'),
      _createEvent(id: 'wrong-sport', city: 'Lima', sport: 'basketball'),
      _createEvent(
        id: 'before-date',
        city: 'Lima',
        date: DateTime(2026, 9, 18),
      ),
    ];

    final result = useCase(
      events: events,
      filters: EventFilters(
        selectedSports: const ['football'],
        selectedCity: 'Lima',
        fromDate: DateTime(2026, 9, 19),
      ),
    );

    expect(result.map((event) => event.id), ['match']);
  });

  test('returns an empty list when no event matches', () {
    final events = [_createEvent(id: 'event-1', city: 'Lima')];

    final result = useCase(
      events: events,
      filters: EventFilters(selectedCity: 'Cusco'),
    );

    expect(result, isEmpty);
  });
}

Event _createEvent({
  required String id,
  required String city,
  String sport = 'football',
  DateTime? date,
}) {
  return Event(
    id: id,
    name: 'Football Match',
    sport: sport,
    date: date ?? DateTime(2026, 9, 19),
    time: '10:00',
    city: city,
    venue: 'Central Stadium',
    totalSlots: 20,
    availableSlots: 10,
    status: EventStatus.open,
  );
}
