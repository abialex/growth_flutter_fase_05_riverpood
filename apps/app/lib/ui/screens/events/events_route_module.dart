import 'package:growth_flutter_fase_05_riverpood/ui/routing/app_route.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/screens/events/events_page.dart';
import 'package:router_core/router_core.dart';

class EventsRouteModule implements IRouteModule {
  @override
  StatefulShellBranch? get branch => null;

  @override
  List<RouteBase> get rootRoutes => [
    GoRoute(
      path: AppRoute.events.path,
      name: AppRoute.events.routeName,
      pageBuilder: (context, state) => AppBuildStackAnimationPage<AppRoute>(
        state: state,
        child: const EventsPage(),
        animationType: AnimationTransitionEnum.fade,
        routeEnum: AppRoute.events,
        routePath: state.matchedLocation,
      ).build(),
    ),
  ];
}
