import 'package:router_core/router_core.dart';

import '../../routing/app_route.dart';
import 'login_page.dart';

class LoginRouteModule implements IRouteModule {
  @override
  StatefulShellBranch? get branch => null;

  @override
  List<RouteBase> get rootRoutes => [
        GoRoute(
          path: AppRoute.login.path,
          name: 'login',
          pageBuilder: (context, state) => AppBuildStackAnimationPage<AppRoute>(
            state: state,
            child: const LoginPage(),
            animationType: AnimationTransitionEnum.fade,
            routeEnum: AppRoute.login,
          ).build(),
        ),
      ];
}
