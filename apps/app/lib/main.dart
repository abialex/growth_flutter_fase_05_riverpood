import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:growth_flutter_fase_05_riverpood/core/supabase_client.dart';
import 'package:growth_flutter_fase_05_riverpood/data/services/app_config_service.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/container.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/routing/app_router_provider.dart';

/// Loads app configuration and dependencies before mounting [MainApp].
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  final appConfig = await AppConfigService().load();
  await initSupabase();
  runApp(
    ProviderScope(
      overrides: [appConfigProvider.overrideWithValue(appConfig)],
      child: const MainApp(),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeNotifierProvider);
    final seedColor = ref.watch(appConfigProvider).theme.seedColor;

    return MaterialApp.router(
      theme: _themeFor(Brightness.light, seedColor),
      darkTheme: _themeFor(Brightness.dark, seedColor),
      themeMode: themeMode,
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}

/// Builds an [AppTheme] variant using the seed color loaded from JSON.
///
/// `app_ui_kit` exposes predefined brands but does not accept a custom seed.
/// This keeps its typography and other theme values while replacing the
/// generated [ColorScheme] and matching semantic color roles.
ThemeData _themeFor(Brightness brightness, Color seedColor) {
  final baseTheme = brightness == Brightness.light
      ? AppTheme.light()
      : AppTheme.dark();
  final colorScheme = ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: brightness,
  );
  final baseRoles = baseTheme.extension<AppColorRoles>();

  return baseTheme.copyWith(
    colorScheme: colorScheme,
    extensions: [
      if (baseRoles != null)
        baseRoles.copyWith(
          primary: colorScheme.primary,
          onPrimary: colorScheme.onPrimary,
          primaryContainer: colorScheme.primaryContainer,
          onPrimaryContainer: colorScheme.onPrimaryContainer,
          secondary: colorScheme.secondary,
          onSecondary: colorScheme.onSecondary,
          background: colorScheme.surface,
          onBackground: colorScheme.onSurface,
          surface: colorScheme.surface,
          onSurface: colorScheme.onSurface,
          error: colorScheme.error,
          onError: colorScheme.onError,
          errorContainer: colorScheme.errorContainer,
          onErrorContainer: colorScheme.onErrorContainer,
        ),
    ],
  );
}
