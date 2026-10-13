import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/login/login_notifier.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/login/login_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/login/states/login_initial_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/container.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/screens/login/login_page.dart';

void main() {
  testWidgets('matches the initial login page golden', (tester) async {
    _configureGoldenSurface(tester);
    await _loadMaterialIconsFont();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          loginNotifierProvider.overrideWith(_LoginPageGoldenTestNotifier.new),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const LoginPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('login_page.png'),
    );
  });
}

void _configureGoldenSurface(WidgetTester tester) {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Future<void> _loadMaterialIconsFont() async {
  final fontLoader = FontLoader('MaterialIcons')
    ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
  await fontLoader.load();
}

final class _LoginPageGoldenTestNotifier extends LoginNotifier {
  @override
  LoginState build() => const LoginInitialState();
}
