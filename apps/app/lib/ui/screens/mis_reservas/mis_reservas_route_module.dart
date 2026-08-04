import 'package:router_core/router_core.dart';

import '../../routing/app_route.dart';
import 'mis_reservas_page.dart';

class MisReservasRouteModule implements IRouteModule {
  @override
  StatefulShellBranch? get branch => null;

  @override
  List<RouteBase> get rootRoutes => [
        GoRoute(
          path: AppRoute.misReservas.path,
          name: 'mis-reservas',
          pageBuilder: (context, state) => AppBuildStackAnimationPage<AppRoute>(
            state: state,
            child: const MisReservasPage(),
            animationType: AnimationTransitionEnum.slideHorizontal,
            routeEnum: AppRoute.misReservas,
          ).build(),
        ),
      ];
}
