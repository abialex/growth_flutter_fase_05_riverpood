import 'package:growth_flutter_fase_05_riverpood/ui/routing/app_route.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/screens/my_reservations/my_reservations_page.dart';
import 'package:router_core/router_core.dart';

class MyReservationsRouteModule implements IRouteModule {
  @override
  StatefulShellBranch? get branch => null;

  @override
  List<RouteBase> get rootRoutes => [
    GoRoute(
      path: AppRoute.myReservations.path,
      name: 'my-reservations',
      pageBuilder: (context, state) => AppBuildStackAnimationPage<AppRoute>(
        state: state,
        child: const MyReservationsPage(),
        animationType: AnimationTransitionEnum.slideHorizontal,
        routeEnum: AppRoute.myReservations,
      ).build(),
    ),
  ];
}
