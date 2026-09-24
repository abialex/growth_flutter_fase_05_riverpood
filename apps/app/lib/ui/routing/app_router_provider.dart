import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:growth_flutter_fase_05_riverpood/domain/enums/auth_status.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/container.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/routing/app_route.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/routing/auth_state_refresh_notifier.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/routing/splash_page.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/screens/events/event_detail_route_module.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/screens/events/events_route_module.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/screens/login/login_route_module.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/screens/my_reservations/my_reservations_route_module.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/screens/register/register_route_module.dart';
import 'package:router_core/router_core.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authStateRefreshNotifier = AuthStateRefreshNotifier();
  ref
    ..onDispose(authStateRefreshNotifier.dispose)
    ..listen<AuthStatus>(authNotifierProvider, (_, _) {
      authStateRefreshNotifier.refresh();
    });

  final appGoRouter = AppGoRouter<AppRoute>(
    mainWrapperBuilder: (navigationShell) => navigationShell,
    routeModules: [
      LoginRouteModule(),
      RegisterRouteModule(),
      EventsRouteModule(),
      EventDetailRouteModule(),
      MyReservationsRouteModule(),
    ],
    updateCurrentRouteEvent: (route) {},
    refreshListenable: authStateRefreshNotifier,
    routeGuard: (context, state) =>
        _redirectForAuthentication(ref.read(authNotifierProvider), state),
    pageSplashBuilder: () => const SplashPage(),
    initialLocation: AppRoute.splash.path,
    getRouteEnumFromPath: AppRoute.fromPath,
  );
  return appGoRouter.router;
});

String? _redirectForAuthentication(
  AuthStatus authStatus,
  GoRouterState state,
) {
  final location = state.matchedLocation;
  final isPublicRoute =
      location == AppRoute.login.path || location == AppRoute.register.path;

  if (authStatus == AuthStatus.loading) {
    return location == AppRoute.splash.path ? null : AppRoute.splash.path;
  }

  if (authStatus == AuthStatus.unauthenticated && !isPublicRoute) {
    return AppRoute.login.path;
  }

  if (authStatus == AuthStatus.authenticated &&
      (isPublicRoute || location == AppRoute.splash.path)) {
    return AppRoute.events.path;
  }

  return null;
}
