import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/routing/app_route.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/routing/splash_page.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/screens/eventos/evento_detalle_route_module.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/screens/eventos/eventos_route_module.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/screens/login/login_route_module.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/screens/mis_reservas/mis_reservas_route_module.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/screens/register/register_route_module.dart';
import 'package:router_core/router_core.dart';

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
