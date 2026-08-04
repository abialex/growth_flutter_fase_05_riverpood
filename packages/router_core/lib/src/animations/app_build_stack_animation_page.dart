import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:router_core/src/animations/animation_transition_enum.dart';
import 'package:router_core/src/mobile/app_back_mobil_handler.dart';

class AppBuildStackAnimationPage<T> {
  const AppBuildStackAnimationPage({
    required this.state,
    required this.child,
    required this.animationType,
    this.routeEnum,
    this.valueKey,
    this.transitionDuration,
  });

  final GoRouterState state;
  final Widget child;
  final AnimationTransitionEnum animationType;
  final Duration? transitionDuration;
  final ValueKey? valueKey;
  final T? routeEnum;

  CustomTransitionPage build() {
    return _buildCustomTransitionPage();
  }

  CustomTransitionPage _buildCustomTransitionPage() {
    // Clave para la transición, si se desea
    final transitionKey = valueKey ?? ValueKey(state.matchedLocation);
    return CustomTransitionPage(
      name: routeEnum?.toString(),
      key: transitionKey,
      child: AppBackMobilHandler(key: transitionKey, child: child),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return _buildTransition(animation, child);
      },
      transitionDuration: transitionDuration ?? const Duration(milliseconds: 300),
    );
  }

  Widget _buildTransition(Animation<double> animation, Widget child) {
    switch (animationType) {
      case AnimationTransitionEnum.fade:
        return FadeTransition(opacity: animation, child: child);

      case AnimationTransitionEnum.slideHorizontal:
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);

      case AnimationTransitionEnum.slideVertical:
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
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
