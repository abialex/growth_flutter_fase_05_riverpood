/// Prevents stale asynchronous results from updating application state.
final class AsyncOperationGuard {
  int _generation = 0;

  /// Starts a new operation and returns its generation.
  int start() => ++_generation;

  /// Returns whether [generation] belongs to the latest operation.
  bool isCurrent(int generation) => generation == _generation;

  /// Invalidates the current operation.
  void cancel() => _generation++;
}
