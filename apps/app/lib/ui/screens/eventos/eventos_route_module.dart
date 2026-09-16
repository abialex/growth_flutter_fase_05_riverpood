import 'package:growth_flutter_fase_05_riverpood/ui/routing/app_route.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/screens/eventos/eventos_page.dart';
import 'package:router_core/router_core.dart';

class EventosRouteModule implements IRouteModule {
  @override
  StatefulShellBranch? get branch => null;

  @override
  List<RouteBase> get rootRoutes => [
    GoRoute(
      path: AppRoute.eventos.path,
      name: 'eventos',
      pageBuilder: (context, state) => AppBuildStackAnimationPage<AppRoute>(
        state: state,
        child: const EventosPage(),
        animationType: AnimationTransitionEnum.fade,
        routeEnum: AppRoute.eventos,
      ).build(),
    ),
  ];
}
