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

  static AppRoute fromPath(String path) {
    return AppRoute.values.firstWhere(
      (route) => route.path == path,
      orElse: () => AppRoute.splash,
    );
  }
}
