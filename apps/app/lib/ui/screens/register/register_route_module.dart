import 'package:router_core/router_core.dart';

import '../../routing/app_route.dart';
import 'register_page.dart';

class RegisterRouteModule implements IRouteModule {
  @override
  StatefulShellBranch? get branch => null;

  @override
  List<RouteBase> get rootRoutes => [
        GoRoute(
          path: AppRoute.register.path,
          name: 'register',
          pageBuilder: (context, state) => AppBuildStackAnimationPage<AppRoute>(
            state: state,
            child: const RegisterPage(),
            animationType: AnimationTransitionEnum.fade,
            routeEnum: AppRoute.register,
          ).build(),
        ),
      ];
}
