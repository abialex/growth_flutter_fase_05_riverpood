# router_core

Reusable routing infrastructure for Flutter applications. The package combines
modular route registration, guarded navigation, route observers and reusable
page transitions on top of `go_router`.

## Requirements

- Dart SDK 3.9.2 or newer.
- Flutter 3.35.0 or newer.

## Installation

Add the package as a local dependency in the application:

```yaml
dependencies:
  router_core:
    path: ../packages/router_core
```

Import the public barrel:

```dart
import 'package:router_core/router_core.dart';
```

## Initialization

Create a route module for each feature. Routes outside a persistent shell are
returned from `rootRoutes`:

```dart
class FeatureRouteModule implements IRouteModule {
  @override
  StatefulShellBranch? get branch => null;

  @override
  List<RouteBase> get rootRoutes => [
    GoRoute(
      name: 'events',
      path: '/events',
      builder: (context, state) => const Placeholder(),
    ),
  ];
}
```

Build the application router by providing the route modules and the
application-specific route mapping:

```dart
enum AppRoute { splash, events }

AppRoute routeFromPath(String path) {
  return path == '/events' ? AppRoute.events : AppRoute.splash;
}

final refreshListenable = ChangeNotifier();
final appRouter = AppGoRouter<AppRoute>(
  mainWrapperBuilder: (navigationShell) => navigationShell,
  routeModules: [FeatureRouteModule()],
  updateCurrentRouteEvent: (route) {},
  refreshListenable: refreshListenable,
  pageSplashBuilder: () => const Placeholder(),
  initialLocation: '/',
  getRouteEnumFromPath: routeFromPath,
);

MaterialApp.router(routerConfig: appRouter.router);
```

Pass an application-owned `routeGuard` when access depends on authentication or
another state condition. Return a path to redirect or `null` to continue.

## Usage

Navigate by route name from a widget or from a post-frame callback:

```dart
context.goNamed('events');
NavigationUtils.navigateSafely('events');
```

Use `AppBuildStackAnimationPage` when a route needs a standard transition:

```dart
pageBuilder: (context, state) =>
    AppBuildStackAnimationPage<AppRoute>(
      state: state,
      child: const Placeholder(),
      animationType: AnimationTransitionEnum.fade,
      routeEnum: AppRoute.events,
    ).build(),
```

## Error handling

`router_core` delegates route parsing and navigation errors to `go_router`. The
package does not expose transport errors or introduce a second routing error
type. Application-specific access failures should be handled by `routeGuard`
and application-specific error pages.

## Public API

| API | Purpose |
| --- | --- |
| `IRouteModule` | Registers root routes and optional shell branches. |
| `AppGoRouter` | Builds the configured `GoRouter`. |
| `AppGoRouterObserver` | Reports route changes and pops. |
| `AppBuildStackAnimationPage` | Builds standard animated route pages. |
| `AnimationTransitionEnum` | Selects the page transition. |
| `AppBackMobileHandler` | Handles mobile back navigation consistently. |
| `NavigationUtils` | Navigates safely outside a widget build. |

## Architecture

The package exposes its consumer-facing API from `lib/router_core.dart`. The
implementation is organized under `lib/src/`, while only the routing types
needed to implement modules are re-exported from `go_router`. The application
owns authentication state and supplies its guard and refresh listenable through
dependency injection.
