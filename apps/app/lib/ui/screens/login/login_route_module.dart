import 'package:growth_flutter_fase_05_riverpood/ui/routing/app_route.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/screens/login/login_page.dart';
import 'package:router_core/router_core.dart';

class LoginRouteModule implements IRouteModule {
  @override
  StatefulShellBranch? get branch => null;

  @override
  List<RouteBase> get rootRoutes => [
    GoRoute(
      path: AppRoute.login.path,
      name: AppRoute.login.routeName,
      pageBuilder: (context, state) => AppBuildStackAnimationPage<AppRoute>(
        state: state,
        child: const LoginPage(),
        animationType: AnimationTransitionEnum.fade,
        routeEnum: AppRoute.login,
        routePath: state.matchedLocation,
      ).build(),
    ),
  ];
}
