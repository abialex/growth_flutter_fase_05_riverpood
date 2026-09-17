enum AppRoute {
  splash,
  login,
  register,
  events,
  eventDetail,
  myReservations;

  String get path => switch (this) {
    AppRoute.splash => '/splash',
    AppRoute.login => '/login',
    AppRoute.register => '/register',
    AppRoute.events => '/eventos',
    AppRoute.eventDetail => '/eventos/:id',
    AppRoute.myReservations => '/mis-reservas',
  };

  String get routeName => switch (this) {
    AppRoute.splash => 'splash',
    AppRoute.login => 'login',
    AppRoute.register => 'register',
    AppRoute.events => 'events',
    AppRoute.eventDetail => 'event-detail',
    AppRoute.myReservations => 'my-reservations',
  };

  static AppRoute fromPath(String path) {
    final normalizedPath = _normalizePath(path);

    for (final route in AppRoute.values) {
      if (route.path == normalizedPath) {
        return route;
      }
    }

    final eventDetailPrefix = '${AppRoute.events.path}/';
    if (normalizedPath.startsWith(eventDetailPrefix) &&
        normalizedPath.length > eventDetailPrefix.length) {
      return AppRoute.eventDetail;
    }

    return AppRoute.splash;
  }

  static String _normalizePath(String path) {
    final pathWithoutQuery = path.split('?').first;
    if (pathWithoutQuery.length > 1 && pathWithoutQuery.endsWith('/')) {
      return pathWithoutQuery.substring(0, pathWithoutQuery.length - 1);
    }
    return pathWithoutQuery;
  }
}
