import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

/// Handles back navigation consistently across mobile routes.
class AppBackMobileHandler extends StatelessWidget {
  /// Creates a back-navigation handler around [child].
  const AppBackMobileHandler({required this.child, super.key});

  /// The route content wrapped by this handler.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        if (context.canPop()) {
          context.pop();
          return;
        }

        final shouldExit =
            await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('¿Salir de la app?'),
                content: const Text('¿Estás seguro de que quieres salir?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Salir'),
                  ),
                ],
              ),
            ) ??
            false;

        if (shouldExit) {
          await SystemNavigator.pop();
        }
      },
      child: child,
    );
  }
}
