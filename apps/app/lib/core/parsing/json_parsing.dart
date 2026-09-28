import 'package:growth_flutter_fase_05_riverpood/core/enums/parsing_failure_reason.dart';
import 'package:growth_flutter_fase_05_riverpood/core/errors/parsing_failure.dart';

/// Parses a required JSON string without hiding missing or invalid data.
String parseRequiredString(dynamic value, {required String field}) {
  if (value == null) {
    throw ParsingFailure(
      field: field,
      reason: ParsingFailureReason.missing,
      expectedType: 'non-empty String',
    );
  }

  if (value is! String) {
    throw ParsingFailure(
      field: field,
      reason: ParsingFailureReason.invalidType,
      expectedType: 'non-empty String',
      actualType: value.runtimeType.toString(),
    );
  }

  if (value.trim().isEmpty) {
    throw ParsingFailure(
      field: field,
      reason: ParsingFailureReason.invalidValue,
      expectedType: 'non-empty String',
    );
  }

  return value;
}

/// Parses a required JSON integer without coercing another type.
int parseRequiredInt(
  dynamic value, {
  required String field,
  int? minimum,
}) {
  if (value == null) {
    throw ParsingFailure(
      field: field,
      reason: ParsingFailureReason.missing,
      expectedType: 'int',
    );
  }

  if (value is! int) {
    throw ParsingFailure(
      field: field,
      reason: ParsingFailureReason.invalidType,
      expectedType: 'int',
      actualType: value.runtimeType.toString(),
    );
  }

  if (minimum != null && value < minimum) {
    throw ParsingFailure(
      field: field,
      reason: ParsingFailureReason.invalidValue,
      expectedType: 'int >= $minimum',
    );
  }

  return value;
}

/// Parses a required JSON date-time string.
DateTime parseRequiredDateTime(dynamic value, {required String field}) {
  if (value == null) {
    throw ParsingFailure(
      field: field,
      reason: ParsingFailureReason.missing,
      expectedType: 'ISO-8601 String',
    );
  }

  if (value is! String) {
    throw ParsingFailure(
      field: field,
      reason: ParsingFailureReason.invalidType,
      expectedType: 'ISO-8601 String',
      actualType: value.runtimeType.toString(),
    );
  }

  final parsedDate = DateTime.tryParse(value);
  if (parsedDate == null) {
    throw ParsingFailure(
      field: field,
      reason: ParsingFailureReason.invalidValue,
      expectedType: 'ISO-8601 String',
    );
  }

  return parsedDate;
}

/// Parses an optional JSON string, returning null for absent or invalid data.
String? parseOptionalString(dynamic value) {
  if (value == null) return null;
  return value is String ? value : null;
}

/// Parses a required JSON list containing only non-empty strings.
List<String> parseRequiredStringList(
  dynamic value, {
  required String field,
}) {
  final values = _parseRequiredList(value, field: field);
  return List.unmodifiable([
    for (var index = 0; index < values.length; index++)
      parseRequiredString(values[index], field: '$field[$index]'),
  ]);
}

/// Parses an optional JSON list containing only non-empty strings.
List<String> parseOptionalStringList(
  dynamic value, {
  required String field,
}) {
  if (value == null) return const [];
  return parseRequiredStringList(value, field: field);
}

/// Parses a required JSON list of objects with a model factory.
List<ModelType> parseRequiredObjectList<ModelType>(
  dynamic value, {
  required String field,
  required ModelType Function(Map<String, dynamic> json) fromJson,
}) {
  final values = _parseRequiredList(value, field: field);
  final models = <ModelType>[];

  for (var index = 0; index < values.length; index++) {
    final itemField = '$field[$index]';
    final json = _parseJsonObject(values[index], field: itemField);
    models.add(fromJson(json));
  }

  return List.unmodifiable(models);
}

/// Parses an optional JSON list of objects with a model factory.
List<ModelType> parseOptionalObjectList<ModelType>(
  dynamic value, {
  required String field,
  required ModelType Function(Map<String, dynamic> json) fromJson,
}) {
  if (value == null) return const [];
  return parseRequiredObjectList(
    value,
    field: field,
    fromJson: fromJson,
  );
}

List<dynamic> _parseRequiredList(
  dynamic value, {
  required String field,
}) {
  if (value == null) {
    throw ParsingFailure(
      field: field,
      reason: ParsingFailureReason.missing,
      expectedType: 'List',
    );
  }

  if (value is! List) {
    throw ParsingFailure(
      field: field,
      reason: ParsingFailureReason.invalidType,
      expectedType: 'List',
      actualType: value.runtimeType.toString(),
    );
  }

  return value;
}

Map<String, dynamic> _parseJsonObject(
  dynamic value, {
  required String field,
}) {
  if (value == null) {
    throw ParsingFailure(
      field: field,
      reason: ParsingFailureReason.missing,
      expectedType: 'JSON object',
    );
  }

  if (value is! Map) {
    throw ParsingFailure(
      field: field,
      reason: ParsingFailureReason.invalidType,
      expectedType: 'JSON object',
      actualType: value.runtimeType.toString(),
    );
  }

  final json = <String, dynamic>{};
  for (final entry in value.entries) {
    if (entry.key is! String) {
      throw ParsingFailure(
        field: field,
        reason: ParsingFailureReason.invalidType,
        expectedType: 'JSON object with String keys',
        actualType: entry.key.runtimeType.toString(),
      );
    }
    json[entry.key as String] = entry.value;
  }
  return json;
}

/// Safely parses a JSON object into a string-keyed map.
Map<String, dynamic> parseMapSafe(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) {
    return value.map((key, mapValue) => MapEntry(key.toString(), mapValue));
  }
  return const {};
}
