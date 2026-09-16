import 'package:go_router/go_router.dart';

/// Defines the contract used to register a group of application routes.
abstract class IRouteModule {
  /// The optional branch displayed inside a persistent shell.
  StatefulShellBranch? get branch => null;

  /// The routes displayed outside the persistent shell.
  List<RouteBase> get rootRoutes => const [];
}
