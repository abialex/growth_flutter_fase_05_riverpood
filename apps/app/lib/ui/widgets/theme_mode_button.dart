import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:growth_flutter_fase_05_riverpood/ui/providers/container.dart';

/// Displays an accessible control for switching the application theme.
class ThemeModeButton extends ConsumerWidget {
  const ThemeModeButton({this.heroTag, super.key});

  /// Optional tag used to animate the control between routes.
  final Object? heroTag;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeNotifierProvider);
    final isDarkMode = themeMode == ThemeMode.dark;
    final button = IconButton(
      icon: Icon(
        isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
      ),
      tooltip: isDarkMode ? 'Activar modo claro' : 'Activar modo oscuro',
      onPressed: () => ref.read(themeModeNotifierProvider.notifier).toggle(),
    );

    final heroTag = this.heroTag;
    if (heroTag == null) {
      return button;
    }

    return Hero(tag: heroTag, child: button);
  }
}
