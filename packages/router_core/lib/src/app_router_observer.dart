import 'package:flutter/material.dart';

/// Observes navigation changes made by the application router.
class AppGoRouterObserver extends NavigatorObserver {
  /// Creates a navigation observer with optional change callbacks.
  AppGoRouterObserver({this.onRouteChange, this.onPop});

  /// Called when the active route changes.
  final void Function(String?)? onRouteChange;

  /// Called when a route is removed from the navigation stack.
  final void Function(String? previousRouteName)? onPop;

  @override
  void didChangeTop(
    Route<dynamic> topRoute,
    Route<dynamic>? previousTopRoute,
  ) {
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
