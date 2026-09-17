/// Categorizes failures exposed by the application.
enum AppFailureType {
  /// The request could not reach the server.
  network,

  /// The requested resource does not exist.
  notFound,

  /// The current user is not authorized.
  unauthorized,

  /// The request contains invalid data.
  validation,

  /// The server rejected or could not process the request.
  server,

  /// The failure has no more specific category.
  unknown,
}
