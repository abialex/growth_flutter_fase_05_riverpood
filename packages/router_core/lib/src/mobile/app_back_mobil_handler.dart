import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class AppBackMobilHandler extends StatelessWidget {
  final Widget child;

  const AppBackMobilHandler({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (kDebugMode) {
          // AppLogger.logDebug('🔙 BackButtonHandler activado!');
        }
        // Verificar si hay páginas anteriores en GoRouter
        if (context.canPop()) {
          if (kDebugMode) {
            // AppLogger.logDebug('⬅️ GoRouter navegando hacia atrás...');
          }
          context.pop();
        } else {
          if (kDebugMode) {
            // AppLogger.logDebug('🚪 GoRouter mostrando diálogo de salida...');
          }
          // Si no hay páginas anteriores, mostrar diálogo de salida
          bool shouldExit = await showDialog<bool>(
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
            SystemNavigator.pop(); // Cerrar la app
          }
        }
      },
      child: child,
    );
  }
}
