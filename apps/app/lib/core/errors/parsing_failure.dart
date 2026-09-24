import 'package:growth_flutter_fase_05_riverpood/core/enums/parsing_failure_reason.dart';

/// Describes invalid persisted data without retaining its payload.
final class ParsingFailure implements Exception {
  /// Creates a parsing failure for a persisted field.
  const ParsingFailure({
    required this.field,
    required this.reason,
    required this.expectedType,
    this.actualType,
  });

  /// The persisted field that could not be parsed.
  final String field;

  /// The reason the value could not be parsed.
  final ParsingFailureReason reason;

  /// The type or shape expected by the parser.
  final String expectedType;

  /// The runtime type received by the parser, when available.
  final String? actualType;

  @override
  String toString() {
    final actualTypeDescription = actualType == null
        ? ''
        : ', actualType: $actualType';
    return 'ParsingFailure(field: $field, reason: ${reason.name}, '
        'expectedType: $expectedType$actualTypeDescription)';
  }
}
