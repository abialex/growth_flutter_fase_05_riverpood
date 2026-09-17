import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:growth_flutter_fase_05_riverpood/domain/repositories/auth_repository.dart';
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
  final authRepository = ref.watch(authRepositoryProvider);
  final authStateRefreshNotifier = AuthStateRefreshNotifier(
    authRepository.authStatusChanges,
  );
  ref.onDispose(authStateRefreshNotifier.dispose);

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
        _redirectForAuthentication(authRepository, state),
    pageSplashBuilder: () => const SplashPage(),
    initialLocation: AppRoute.splash.path,
    getRouteEnumFromPath: AppRoute.fromPath,
    getPathFromRouteEnum: (route) => route.path,
  );
  return appGoRouter.router;
});

String? _redirectForAuthentication(
  AuthRepository authRepository,
  GoRouterState state,
) {
  final location = state.matchedLocation;
  final isPublicRoute =
      location == AppRoute.login.path || location == AppRoute.register.path;
  final isAuthenticated = authRepository.isAuthenticated;

  if (!isAuthenticated && !isPublicRoute) {
    return AppRoute.login.path;
  }

  if (isAuthenticated && (isPublicRoute || location == AppRoute.splash.path)) {
    return AppRoute.events.path;
  }

  return null;
}
