enum AppRoute {
  splash,
  login,
  register,
  eventos,
  eventoDetalle,
  misReservas;

  // NOTA: eventoDetalle.path es el patrón que registra GoRoute ('/eventos/:id'),
  // no una URL real navegable. Con un id real en la URL, fromPath() no lo va a
  // reconocer (cae al fallback splash) — eso solo afecta el bookkeeping interno
  // de router_core (currentRoute/previousRoute), hoy un no-op. El matching real
  // de rutas lo hace go_router internamente vía GoRoute(path:), no este enum.
  String get path => switch (this) {
    AppRoute.splash => '/splash',
    AppRoute.login => '/login',
    AppRoute.register => '/register',
    AppRoute.eventos => '/eventos',
    AppRoute.eventoDetalle => '/eventos/:id',
    AppRoute.misReservas => '/mis-reservas',
  };

  static AppRoute fromPath(String path) {
    return AppRoute.values.firstWhere(
      (route) => route.path == path,
      orElse: () => AppRoute.splash,
    );
  }
}
