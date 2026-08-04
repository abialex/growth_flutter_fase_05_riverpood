import 'package:flutter/material.dart';

/// Observador personalizado para monitorear la navegación
class AppGoRouterObserver extends NavigatorObserver {
  final void Function(String?)? onRouteChange;

  /// Callback específico para cuando se hace pop (incluyendo Navigator.of(context).pop())
  final void Function(String? previousRouteName)? onPop;

  AppGoRouterObserver({this.onRouteChange, this.onPop});

  @override
  void didChangeTop(Route topRoute, Route? previousTopRoute) {
    onRouteChange?.call(topRoute.settings.name);
    super.didChangeTop(topRoute, previousTopRoute);
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    onRouteChange?.call(route.settings.name);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    onRouteChange?.call(previousRoute?.settings.name);
    onPop?.call(previousRoute?.settings.name);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    onRouteChange?.call(previousRoute?.settings.name);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    onRouteChange?.call(newRoute?.settings.name);
  }
}
