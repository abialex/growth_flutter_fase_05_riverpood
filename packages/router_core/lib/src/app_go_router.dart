import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:router_core/src/animations/animation_transition_enum.dart';
import 'package:router_core/src/animations/app_build_stack_animation_page.dart';
import 'package:router_core/src/app_router_observer.dart';
import 'package:router_core/src/i_route_module.dart';

/// Root navigator key shared by the router and navigation utilities.
final GlobalKey<NavigatorState> appRootNavigatorKey =
    GlobalKey<NavigatorState>();

/// Builds a modular [GoRouter] from registered route modules.
class AppGoRouter<T> {
  /// Creates a router from the supplied route modules and application hooks.
  AppGoRouter({
    required this.mainWrapperBuilder,
    required List<IRouteModule> routeModules,
    required this.updateCurrentRouteEvent,
    required this.refreshListenable,
    required this.pageSplashBuilder,
    required this.initialLocation,
    required this.getRouteEnumFromPath,
    this.onRouteChange,
    this.routeGuard,
  }) : routeModules = List.unmodifiable(routeModules) {
    final goRouterList = routeModules
        .expand((module) => module.rootRoutes)
        .toList();
    _router = GoRouter(
      navigatorKey: appRootNavigatorKey,
      observers: [
        AppGoRouterObserver(
          onRouteChange: onRouteChange,
          onPop: (routeName) {
            if (routeName == null) return;
            final routeEnum = getRouteEnumFromPath(routeName);
            _updateCurrentRoute(routeEnum);
            updateCurrentRouteEvent(routeEnum);
          },
        ),
      ],
      debugLogDiagnostics: kDebugMode,
      initialLocation: initialLocation,
      refreshListenable: refreshListenable,
      routes: [
        GoRoute(
          path: initialLocation,
          name: 'splash',
          pageBuilder: (context, state) => AppBuildStackAnimationPage<T>(
            state: state,
            child: pageSplashBuilder(),
            animationType: AnimationTransitionEnum.fade,
            routePath: state.matchedLocation,
          ).build(),
        ),
        ...goRouterList,
        if (routeModules.any((module) => module.branch != null))
          StatefulShellRoute.indexedStack(
            builder: (context, state, navigationShell) {
              return mainWrapperBuilder(navigationShell);
            },
            branches: routeModules
                .map((m) => m.branch)
                .whereType<StatefulShellBranch>()
                .toList(),
          ),
      ],
      redirect: (context, state) {
        final routeEnum = _getRouteEnum(state);
        _updateCurrentRoute(routeEnum);
        updateCurrentRouteEvent(routeEnum);
        return routeGuard?.call(context, state);
      },
    );
  }
  late final GoRouter _router;

  /// The route modules registered with this router.
  final List<IRouteModule> routeModules;

  /// Called when the current route changes.
  final void Function(T route) updateCurrentRouteEvent;

  /// Listenable used to refresh the router state.
  final Listenable? refreshListenable;

  T? _currentRoute;

  T? _previousRoute;

  /// The current route identifier.
  T? get currentRoute => _currentRoute;

  /// The previous route identifier.
  T? get previousRoute => _previousRoute;

  /// Builds the splash screen shown at the initial route.
  final Widget Function() pageSplashBuilder;

  /// The initial route location.
  final String initialLocation;

  /// Converts a route path to its route identifier.
  final T Function(String path) getRouteEnumFromPath;

  /// Called after the active route name changes.
  final void Function(String? routeName)? onRouteChange;

  /// Optionally redirects a route based on application state.
  final GoRouterRedirect? routeGuard;

  /// Builds the persistent application shell.
  final Widget Function(StatefulNavigationShell navigationShell)
  mainWrapperBuilder;

  /// The configured GoRouter instance.
  GoRouter get router => _router;

  void _updateCurrentRoute(T route) {
    _previousRoute = _currentRoute;
    _currentRoute = route;
  }

  T _getRouteEnum(GoRouterState state) {
    return getRouteEnumFromPath(state.matchedLocation);
  }
}
