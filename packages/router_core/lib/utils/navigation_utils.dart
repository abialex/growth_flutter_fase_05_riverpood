import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:router_core/src/app_go_router.dart';

/// Provides navigation helpers that can be called outside a widget build.
class NavigationUtils {
  /// Navigates to [routeName] after the current frame completes when possible.
  static void navigateSafely(String routeName) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = appRootNavigatorKey.currentContext;
      if (context != null && context.mounted) {
        context.goNamed(routeName);
      }
    });
  }
}
