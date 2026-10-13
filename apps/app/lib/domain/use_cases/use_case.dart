/// Defines a use case with typed input parameters and output.
// ignore: one_member_abstracts
abstract interface class UseCase<Params, Output> {
  /// Runs the use case with [params].
  Output call(Params params);
}

/// Represents the absence of input parameters for a [UseCase].
final class NoParams {
  /// Creates an empty parameter value.
  const NoParams();
}
