import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:router_core/router_core.dart';

import '../screens/eventos/evento_detalle_route_module.dart';
import '../screens/eventos/eventos_route_module.dart';
import '../screens/login/login_route_module.dart';
import '../screens/mis_reservas/mis_reservas_route_module.dart';
import '../screens/register/register_route_module.dart';
import 'app_route.dart';
import 'splash_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final appGoRouter = AppGoRouter<AppRoute>(
    mainWrapperBuilder: (navigationShell) => navigationShell,
    routeModules: [
      LoginRouteModule(),
      RegisterRouteModule(),
      EventosRouteModule(),
      EventoDetalleRouteModule(),
      MisReservasRouteModule(),
    ],
    updateCurrentRouteEvent: (route) {},
    refreshListenable: null,
    pageSplashBuilder: () => const SplashPage(),
    initialLocation: AppRoute.splash.path,
    getRouteEnumFromPath: AppRoute.fromPath,
    getPathFromRouteEnum: (route) => route.path,
  );
  return appGoRouter.router;
});
