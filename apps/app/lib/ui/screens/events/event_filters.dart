import 'package:growth_flutter_fase_05_riverpood/domain/entities/event.dart';
import 'package:meta/meta.dart';

/// Describes the filters applied to the events list.
@immutable
final class EventFilters {
  /// Creates event filters.
  EventFilters({
    Iterable<String> selectedSports = const <String>[],
    this.selectedCity,
    this.fromDate,
  }) : selectedSports = Set.unmodifiable(selectedSports);

  /// Sports that an event must match. An empty set matches every sport.
  final Set<String> selectedSports;

  /// City that an event must match, or `null` for every city.
  final String? selectedCity;

  /// Inclusive lower bound for the event date, or `null` for any date.
  final DateTime? fromDate;

  /// Whether at least one filter is active.
  bool get hasActiveFilters {
    return selectedSports.isNotEmpty ||
        selectedCity != null ||
        fromDate != null;
  }

  /// Returns a copy with [sport] selected or unselected.
  EventFilters toggleSport(String sport, {required bool isSelected}) {
    final updatedSports = {...selectedSports};
    if (isSelected) {
      updatedSports.add(sport);
    } else {
      updatedSports.remove(sport);
    }
    return EventFilters(
      selectedSports: updatedSports,
      selectedCity: selectedCity,
      fromDate: fromDate,
    );
  }

  /// Returns a copy with the selected city.
  EventFilters selectCity(String? city) {
    return EventFilters(
      selectedSports: selectedSports,
      selectedCity: city,
      fromDate: fromDate,
    );
  }

  /// Returns a copy with the inclusive lower date bound.
  EventFilters selectFromDate(DateTime? date) {
    return EventFilters(
      selectedSports: selectedSports,
      selectedCity: selectedCity,
      fromDate: date,
    );
  }

  /// Returns an empty filter set.
  EventFilters clear() => EventFilters();

  /// Whether [event] satisfies every active filter.
  bool matches(Event event) {
    if (selectedSports.isNotEmpty && !selectedSports.contains(event.sport)) {
      return false;
    }
    if (selectedCity != null && event.city != selectedCity) {
      return false;
    }
    final selectedFromDate = fromDate;
    if (selectedFromDate != null && event.date.isBefore(selectedFromDate)) {
      return false;
    }
    return true;
  }
}
