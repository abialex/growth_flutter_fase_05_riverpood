import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../src/app_go_router.dart';

class NavigationUtils {
  static void navigateSafely(String routeName) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = approotNavigatorKey.currentContext;
      if (context != null && context.mounted) {
        context.goNamed(routeName);
      }
    });
  }
}
