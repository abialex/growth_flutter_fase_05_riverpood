import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:router_core/src/animations/animation_transition_enum.dart';
import 'package:router_core/src/animations/app_build_stack_animation_page.dart';
import 'package:router_core/src/app_router_observer.dart';
import 'package:router_core/src/i_route_module.dart';

/// Root navigator key shared by the router and navigation utilities.
final GlobalKey<NavigatorState> approotNavigatorKey =
    GlobalKey<NavigatorState>();

/// Builds a modular [GoRouter] from registered route modules.
class AppGoRouter<T> {
  /// Creates a router from the supplied route modules and application hooks.
  AppGoRouter({
    required this.mainWrapperBuilder,
    required this.routeModules,
    required this.updateCurrentRouteEvent,
    required this.refreshListenable,
    required this.pageSplashBuilder,
    required this.initialLocation,
    required this.getRouteEnumFromPath,
    required this.getPathFromRouteEnum,
    this.onRouteChange,
  }) {
    final goRouterList =
        routeModules.expand((module) => module.rootRoutes).toList();
    _router = GoRouter(
      navigatorKey: approotNavigatorKey,
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
      debugLogDiagnostics: true,
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

        if (!_validateUpdateRouteHistory()) {
          return null;
        }

        return _handlePermissions();
      },
    );
  }
  late GoRouter _router;

  /// The route modules registered with this router.
  List<IRouteModule> routeModules;

  /// Called when the current route changes.
  void Function(T route) updateCurrentRouteEvent;

  /// Listenable used to refresh the router state.
  Listenable? refreshListenable;

  /// The current route identifier.
  T? currentRoute;

  /// The previous route identifier.
  T? previousRoute;

  /// Builds the splash screen shown at the initial route.
  final Widget Function() pageSplashBuilder;

  /// The initial route location.
  final String initialLocation;

  /// Converts a route path to its route identifier.
  final T Function(String path) getRouteEnumFromPath;

  /// Converts a route identifier to its route path.
  final String Function(T route) getPathFromRouteEnum;

  /// Called after the active route name changes.
  final void Function(String? routeName)? onRouteChange;

  /// Builds the persistent application shell.
  final Widget Function(StatefulNavigationShell navigationShell)
      mainWrapperBuilder;

  /// The configured GoRouter instance.
  GoRouter get router => _router;

  bool _validateUpdateRouteHistory() {
    return currentRoute != null &&
        previousRoute != null &&
        currentRoute == previousRoute;
  }

  void _updateCurrentRoute(T route) {
    previousRoute = currentRoute;
    currentRoute = route;
  }

  T _getRouteEnum(GoRouterState state) {
    final path = state.matchedLocation;
    final lastSegment = '/${path.split('/').last}';
    return getRouteEnumFromPath(lastSegment);
  }

  String? _handlePermissions() {
    return null;
  }
}
