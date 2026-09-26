import 'package:growth_flutter_fase_05_riverpood/domain/entities/event.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/event_filters.dart';

/// Returns the events that satisfy every active filter.
final class FilterEventsUseCase {
  /// Creates an event filter evaluator.
  const FilterEventsUseCase();

  /// Filters [events] using the selected criteria in [filters].
  List<Event> call({
    required Iterable<Event> events,
    required EventFilters filters,
  }) {
    return List.unmodifiable(
      events.where((event) => _matches(event, filters)),
    );
  }

  bool _matches(Event event, EventFilters filters) {
    if (filters.selectedSports.isNotEmpty &&
        !filters.selectedSports.contains(event.sport)) {
      return false;
    }
    if (filters.selectedCity != null && event.city != filters.selectedCity) {
      return false;
    }
    final selectedFromDate = filters.fromDate;
    if (selectedFromDate != null && event.date.isBefore(selectedFromDate)) {
      return false;
    }
    return true;
  }
}
