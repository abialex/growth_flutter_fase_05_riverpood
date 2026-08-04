import 'package:go_router/go_router.dart';

/// Interfaz que define el contrato para todos los módulos de rutas
/// Cada módulo debe implementar esta interfaz para registrar sus rutas
abstract class IRouteModule {
  // Para las pestañas que viven dentro del Shell persistente
  StatefulShellBranch? get branch => null;

  // Para pantallas que "tapan" todo el app (Login, Splash, etc.)
  List<RouteBase> get rootRoutes => const [];

  //bool canAccess(String routePath);
  // void clearCache();
}
