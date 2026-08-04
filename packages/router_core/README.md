# Router Core

Core routing infrastructure for dental ecosystem Flutter applications.

## Features

- **Modular Route System**: Define routes using the `IRouteModule` interface
- **GoRouter Integration**: Built on top of GoRouter for declarative routing
- **Custom Animations**: Support for multiple page transition animations
- **Mobile Back Handler**: Intelligent back button handling for mobile platforms
- **Route Observer**: Navigation event monitoring and logging
- **Permission-based Routing**: Support for route access control

## Usage

### 1. Implement IRouteModule

```dart
class MyFeatureRouteModule implements IRouteModule {
  @override
  List<GoRoute> getRoutesMovil() => [...];

  @override
  List<ShellRoute> getShellRoutesMovil() => [...];

  @override
  bool canAccess(String routePath) => true;

  @override
  void clearCache() {}
}
```

### 2. Create Router Instance

```dart
final router = AppGoRouter(
  routeModules: [
    MyFeatureRouteModule(),
    AnotherFeatureRouteModule(),
  ],
  updateCurrentRouteEvent: (route) => handleRouteChange(route),
  refreshListenable: authNotifier,
  pageSplashBuilder: () => const SplashPage(),
);
```

### 3. Use in MaterialApp

```dart
MaterialApp.router(
  routerConfig: router.router,
  // ...
);
```

## Animation Types

- `fade` - Fade in/out transition
- `slideHorizontal` - Slide from right to left
- `slideVertical` - Slide from bottom to top
- `scale` - Scale transition
- `rotation` - Rotation transition
- `none` - No animation

## Dependencies

- `flutter`
- `go_router`
- `dental_core` (for logging utilities)
