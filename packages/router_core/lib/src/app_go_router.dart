import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:router_core/src/animations/animation_transition_enum.dart';
import 'package:router_core/src/animations/app_build_stack_animation_page.dart';
import 'package:router_core/src/i_route_module.dart';
import 'package:router_core/src/app_router_observer.dart';

final GlobalKey<NavigatorState> approotNavigatorKey = GlobalKey<NavigatorState>();

/// Router V1 - Desacoplado usando Route Registry Pattern
class AppGoRouter<T> {
  late GoRouter _router;

  /// Lista de rutas GoRoute y ShellRoute registradas
  List<IRouteModule> routeModules;

  /// Evento para actualizar la ruta actual
  void Function(T route) updateCurrentRouteEvent;

  /// Notificador para refrescar la UI
  Listenable? refreshListenable;

  /// para manejar la ruta actual y la anterior
  T? currentRoute;
  T? previousRoute;

  ///
  final Widget Function() pageSplashBuilder;

  /// Ruta inicial de la aplicación
  final String initialLocation;

  /// Función para obtener el enum de ruta a partir del path
  final T Function(String path) getRouteEnumFromPath;

  /// Función para obtener el path a partir del enum de ruta
  final String Function(T route) getPathFromRouteEnum;

  /// Callback que se dispara cada vez que cambia la ruta activa
  final void Function(String? routeName)? onRouteChange;

  ///
  final Widget Function(StatefulNavigationShell navigationShell) mainWrapperBuilder;

  GoRouter get router => _router;

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
    final goRouterList = routeModules.expand((module) => module.rootRoutes).toList();
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
      routerNeglect: false,
      initialLocation: initialLocation,
      refreshListenable: refreshListenable,
      routes: [
        GoRoute(
          path: initialLocation,
          name: 'splash',
          pageBuilder: (context, state) => AppBuildStackAnimationPage<T>(
            routeEnum: null,
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
                .whereType<StatefulShellBranch>() // Filtramos los módulos que no tienen pestaña
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

        return _handledPermisos(state);
      },
    );
  }

  bool _validateUpdateRouteHistory() {
    return currentRoute != null && previousRoute != null && currentRoute == previousRoute;
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

  String? _handledPermisos(GoRouterState state) {
    // ✅ Usar validators desacoplados en lugar de hardcodear lógica de permisos
    // Cada módulo valida sus propias rutas a través de IRoutePermission
    // final routePermissions = routeModules.map((element) => element.canAccess).toList();

    // Permitir acceso a la ruta
    return null;
  }
}
