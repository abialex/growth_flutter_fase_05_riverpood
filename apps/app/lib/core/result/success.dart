part of 'result.dart';

/// Represents a successful operation with its returned value.
final class Success<SuccessType, FailureType>
    extends Result<SuccessType, FailureType> {
  /// Creates a successful result.
  const Success(this.value);

  /// The value returned by the operation.
  final SuccessType value;
}
