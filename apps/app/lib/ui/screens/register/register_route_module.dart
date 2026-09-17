import 'package:growth_flutter_fase_05_riverpood/ui/routing/app_route.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/screens/register/register_page.dart';
import 'package:router_core/router_core.dart';

class RegisterRouteModule implements IRouteModule {
  @override
  StatefulShellBranch? get branch => null;

  @override
  List<RouteBase> get rootRoutes => [
    GoRoute(
      path: AppRoute.register.path,
      name: AppRoute.register.routeName,
      pageBuilder: (context, state) => AppBuildStackAnimationPage<AppRoute>(
        state: state,
        child: const RegisterPage(),
        animationType: AnimationTransitionEnum.fade,
        routeEnum: AppRoute.register,
        routePath: state.matchedLocation,
      ).build(),
    ),
  ];
}
