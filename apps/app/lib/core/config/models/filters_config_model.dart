import 'package:growth_flutter_fase_05_riverpood/core/parsing/json_parsing.dart';

/// Label configuration for event filters.
class FiltersConfigModel {
  /// Creates event filter label configuration.
  const FiltersConfigModel({
    required this.cityLabel,
    required this.allCitiesHint,
    required this.dateLabel,
    required this.anyDateHint,
    required this.clearLabel,
  });

  /// Converts decoded JSON into event filter label configuration.
  factory FiltersConfigModel.fromJson(Map<String, dynamic> json) {
    return FiltersConfigModel(
      cityLabel: parseRequiredString(
        json['cityLabel'],
        field: 'filters.cityLabel',
      ),
      allCitiesHint: parseRequiredString(
        json['allCitiesHint'],
        field: 'filters.allCitiesHint',
      ),
      dateLabel: parseRequiredString(
        json['dateLabel'],
        field: 'filters.dateLabel',
      ),
      anyDateHint: parseRequiredString(
        json['anyDateHint'],
        field: 'filters.anyDateHint',
      ),
      clearLabel: parseRequiredString(
        json['clearLabel'],
        field: 'filters.clearLabel',
      ),
    );
  }

  /// City filter label.
  final String cityLabel;

  /// Hint for showing events from all cities.
  final String allCitiesHint;

  /// Start date filter label.
  final String dateLabel;

  /// Hint for selecting any start date.
  final String anyDateHint;

  /// Label for clearing active filters.
  final String clearLabel;
}
