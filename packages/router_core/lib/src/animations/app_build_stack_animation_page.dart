import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:router_core/src/animations/animation_transition_enum.dart';
import 'package:router_core/src/mobile/app_back_mobil_handler.dart';

/// Builds a [CustomTransitionPage] with a configurable page transition.
class AppBuildStackAnimationPage<T> {
  /// Creates an animated page builder.
  const AppBuildStackAnimationPage({
    required this.state,
    required this.child,
    required this.animationType,
    this.routeEnum,
    this.valueKey,
    this.transitionDuration,
  });

  /// The current GoRouter state.
  final GoRouterState state;

  /// The widget displayed by the page.
  final Widget child;

  /// The animation applied while the page is entering or leaving.
  final AnimationTransitionEnum animationType;

  /// The duration of the page transition.
  final Duration? transitionDuration;

  /// An optional key used to identify the page transition.
  final ValueKey<Object>? valueKey;

  /// An optional route identifier used as the page name.
  final T? routeEnum;

  /// Builds the configured transition page.
  CustomTransitionPage<void> build() {
    return _buildCustomTransitionPage();
  }

  CustomTransitionPage<void> _buildCustomTransitionPage() {
    final transitionKey = valueKey ?? ValueKey(state.matchedLocation);
    return CustomTransitionPage<void>(
      name: routeEnum?.toString(),
      key: transitionKey,
      child: AppBackMobilHandler(key: transitionKey, child: child),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return _buildTransition(animation, child);
      },
      transitionDuration:
          transitionDuration ?? const Duration(milliseconds: 300),
    );
  }

  Widget _buildTransition(Animation<double> animation, Widget child) {
    switch (animationType) {
      case AnimationTransitionEnum.fade:
        return FadeTransition(opacity: animation, child: child);

      case AnimationTransitionEnum.slideHorizontal:
        const begin = Offset(1, 0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        final offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);

      case AnimationTransitionEnum.slideVertical:
        const begin = Offset(0, 1);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        final offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);

      case AnimationTransitionEnum.scale:
        return ScaleTransition(scale: animation, child: child);

      case AnimationTransitionEnum.rotation:
        return RotationTransition(turns: animation, child: child);

      case AnimationTransitionEnum.none:
        return child;
    }
  }
}
