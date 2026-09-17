part of 'result.dart';

/// Represents a failed operation with its failure value.
final class Failure<SuccessType, FailureType>
    extends Result<SuccessType, FailureType> {
  /// Creates a failed result.
  const Failure(this.failure);

  /// The failure returned by the operation.
  final FailureType failure;
}
