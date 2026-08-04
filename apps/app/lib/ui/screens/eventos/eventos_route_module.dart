import 'package:router_core/router_core.dart';

import '../../routing/app_route.dart';
import 'eventos_page.dart';

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
