/// Safely parses a JSON value into an integer.
int parseIntSafe(dynamic value, {int fallback = 0}) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? fallback;
  return fallback;
}

/// Safely parses a JSON value into a string.
String parseStringSafe(dynamic value, {String fallback = ''}) {
  if (value is String) return value;
  if (value == null) return fallback;
  return value.toString();
}

/// Safely parses an optional JSON string.
String? parseNullableStringSafe(dynamic value) {
  if (value == null) return null;
  return parseStringSafe(value);
}

/// Safely parses a JSON value into a date.
DateTime parseDateTimeSafe(dynamic value) {
  if (value is DateTime) return value;
  if (value is String) {
    final parsedDate = DateTime.tryParse(value);
    if (parsedDate != null) return parsedDate;
  }
  return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
}

/// Safely parses a JSON list into strings.
List<String> parseStringListSafe(dynamic value) {
  if (value is! List) return const [];
  return value.map(parseStringSafe).toList();
}

/// Safely parses a JSON object into a string-keyed map.
Map<String, dynamic> parseMapSafe(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) {
    return value.map((key, mapValue) => MapEntry(key.toString(), mapValue));
  }
  return const {};
}
