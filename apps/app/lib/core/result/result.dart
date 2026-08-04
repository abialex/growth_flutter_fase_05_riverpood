sealed class Result<SuccessType, FailureType> {
  const Result();
}

final class Success<SuccessType, FailureType>
    extends Result<SuccessType, FailureType> {
  const Success(this.value);

  final SuccessType value;
}

final class Failure<SuccessType, FailureType>
    extends Result<SuccessType, FailureType> {
  const Failure(this.failure);

  final FailureType failure;
}
