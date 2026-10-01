/// Describes the authentication state exposed to the application.
enum AuthStatus {
  /// The initial session is still being resolved.
  loading,

  /// A valid authenticated session is available.
  authenticated,

  /// No authenticated session is available.
  unauthenticated,
}
