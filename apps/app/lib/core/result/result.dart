part 'failure.dart';
part 'success.dart';

/// Represents either a successful result or a failure.
sealed class Result<SuccessType, FailureType> {
  const Result();
}
