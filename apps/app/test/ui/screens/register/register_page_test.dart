import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:growth_flutter_fase_05_riverpood/core/enums/app_failure_type.dart';
import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/register/register_notifier.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/register/register_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/register/states/register_error_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/register/states/register_initial_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/register/states/register_loading_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/register/states/register_success_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/container.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/routing/app_route.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/screens/register/register_page.dart';
import 'package:router_core/router_core.dart';

void main() {
  testWidgets('shows the account creation form in its initial state', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          registerNotifierProvider.overrideWith(
            _RegisterPageTestNotifier.new,
          ),
        ],
        child: const MaterialApp(home: RegisterPage()),
      ),
    );

    expect(find.text('Crear cuenta'), findsOneWidget);
    expect(find.text('Nombre'), findsOneWidget);
    expect(find.text('Correo'), findsOneWidget);
    expect(find.text('Contraseña'), findsOneWidget);
    expect(find.text('Ciudad (opcional)'), findsOneWidget);
    expect(find.text('Registrarme'), findsOneWidget);
  });

  testWidgets('toggles password visibility from the password field', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          registerNotifierProvider.overrideWith(
            _RegisterPageTestNotifier.new,
          ),
        ],
        child: const MaterialApp(home: RegisterPage()),
      ),
    );

    final passwordField = find.byType(TextField).at(2);
    expect(tester.widget<TextField>(passwordField).obscureText, isTrue);
    expect(find.byTooltip('Mostrar contraseña'), findsOneWidget);

    await tester.tap(find.byTooltip('Mostrar contraseña'));
    await tester.pump();

    expect(tester.widget<TextField>(passwordField).obscureText, isFalse);
    expect(find.byTooltip('Ocultar contraseña'), findsOneWidget);
  });

  testWidgets('returns to the previous page using the app bar back button', (
    tester,
  ) async {
    final router = GoRouter(
      initialLocation: AppRoute.login.path,
      routes: [
        GoRoute(
          path: AppRoute.login.path,
          builder: (context, state) => Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () => context.push(AppRoute.register.path),
                child: const Text('Abrir registro'),
              ),
            ),
          ),
        ),
        GoRoute(
          path: AppRoute.register.path,
          builder: (context, state) => const RegisterPage(),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          registerNotifierProvider.overrideWith(
            _RegisterPageTestNotifier.new,
          ),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Abrir registro'));
    await tester.pumpAndSettle();
    expect(find.text('Crear cuenta'), findsOneWidget);
    expect(find.byType(BackButton), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    expect(find.text('Abrir registro'), findsOneWidget);
  });

  testWidgets('shows required errors when submitting an empty form', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          registerNotifierProvider.overrideWith(
            _RegisterPageSubmitTestNotifier.new,
          ),
        ],
        child: const MaterialApp(home: RegisterPage()),
      ),
    );

    await tester.tap(find.text('Registrarme'));
    await tester.pump();

    expect(find.text('Ingresa tu nombre.'), findsOneWidget);
    expect(find.text('Ingresa tu correo.'), findsOneWidget);
    expect(find.text('Ingresa tu contraseña.'), findsOneWidget);
    expect(find.text('Ciudad (opcional)'), findsOneWidget);
    expect(find.text('Creando tu cuenta...'), findsNothing);
    expect(find.text('Registrarme'), findsOneWidget);
  });

  testWidgets('shows format and length errors for invalid values', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          registerNotifierProvider.overrideWith(
            _RegisterPageSubmitTestNotifier.new,
          ),
        ],
        child: const MaterialApp(home: RegisterPage()),
      ),
    );

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'A');
    await tester.enterText(fields.at(1), 'correo-sin-formato');
    await tester.enterText(fields.at(2), '12345');
    await tester.tap(find.text('Registrarme'));
    await tester.pump();

    expect(find.text('Ingresa un nombre válido.'), findsOneWidget);
    expect(find.text('Ingresa un correo válido.'), findsOneWidget);
    expect(find.text('Usa al menos 6 caracteres.'), findsOneWidget);
    expect(find.text('Creando tu cuenta...'), findsNothing);
    expect(find.text('Registrarme'), findsOneWidget);
  });

  testWidgets('starts registration when valid fields omit the optional city', (
    tester,
  ) async {
    var wasSubmitted = false;
    String? submittedCity;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          registerNotifierProvider.overrideWith(
            () => _RegisterPageLoadingTestNotifier((city) {
              wasSubmitted = true;
              submittedCity = city;
            }),
          ),
        ],
        child: const MaterialApp(home: RegisterPage()),
      ),
    );

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'Lucia Perez');
    await tester.enterText(fields.at(1), 'lucia@example.com');
    await tester.enterText(fields.at(2), 'secure123');
    await tester.tap(find.text('Registrarme'));
    await tester.pump();

    expect(wasSubmitted, isTrue);
    expect(submittedCity, isNull);
    expect(find.text('Creando tu cuenta...'), findsOneWidget);
    expect(find.text('Registrarme'), findsNothing);

    final renderedFields = tester.widgetList<TextField>(fields);
    expect(renderedFields.length, 4);
    expect(renderedFields.every((field) => field.enabled == false), isTrue);
  });

  testWidgets('shows an error when the email is already registered', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          registerNotifierProvider.overrideWith(
            _RegisterPageErrorTestNotifier.new,
          ),
        ],
        child: const MaterialApp(home: RegisterPage()),
      ),
    );

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'Lucia Perez');
    await tester.enterText(fields.at(1), 'lucia@example.com');
    await tester.enterText(fields.at(2), 'secure123');
    await tester.tap(find.text('Registrarme'));
    await tester.pump();

    expect(find.text('El correo ya está registrado.'), findsOneWidget);
    expect(find.text('Registrarme'), findsOneWidget);
    expect(find.text('Creando tu cuenta...'), findsNothing);
  });

  testWidgets('shows a success message after registration succeeds', (
    tester,
  ) async {
    final router = GoRouter(
      initialLocation: AppRoute.register.path,
      routes: [
        GoRoute(
          path: AppRoute.register.path,
          builder: (context, state) => const RegisterPage(),
        ),
        GoRoute(
          path: AppRoute.login.path,
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('Pantalla de login'))),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          registerNotifierProvider.overrideWith(
            _RegisterPageSuccessTestNotifier.new,
          ),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'Lucia Perez');
    await tester.enterText(fields.at(1), 'lucia@example.com');
    await tester.enterText(fields.at(2), 'secure123');
    await tester.tap(find.text('Registrarme'));
    await tester.pump();

    expect(find.text('Registro exitoso'), findsOneWidget);
    expect(find.text('Registrarme'), findsNothing);
    expect(find.text('Creando tu cuenta...'), findsNothing);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text('Pantalla de login'), findsOneWidget);
  });
}

final class _RegisterPageTestNotifier extends RegisterNotifier {
  @override
  RegisterState build() => const RegisterInitialState();
}

final class _RegisterPageSubmitTestNotifier extends RegisterNotifier {
  @override
  RegisterState build() => const RegisterInitialState();

  @override
  Future<void> onRegister({
    required String email,
    required String password,
    required String name,
    String? city,
  }) async {
    state = const RegisterLoadingState();
  }
}

final class _RegisterPageLoadingTestNotifier extends RegisterNotifier {
  _RegisterPageLoadingTestNotifier(this.onRegisterCalled);

  final void Function(String? city) onRegisterCalled;

  @override
  RegisterState build() => const RegisterInitialState();

  @override
  Future<void> onRegister({
    required String email,
    required String password,
    required String name,
    String? city,
  }) async {
    onRegisterCalled(city);
    state = const RegisterLoadingState();
  }
}

final class _RegisterPageErrorTestNotifier extends RegisterNotifier {
  @override
  RegisterState build() => const RegisterInitialState();

  @override
  Future<void> onRegister({
    required String email,
    required String password,
    required String name,
    String? city,
  }) async {
    state =
        const RegisterErrorState(
          AppFailure(
            failureType: AppFailureType.unauthorized,
            message: 'El correo ya está registrado.',
          ),
        );
  }
}

final class _RegisterPageSuccessTestNotifier extends RegisterNotifier {
  @override
  RegisterState build() => const RegisterInitialState();

  @override
  Future<void> onRegister({
    required String email,
    required String password,
    required String name,
    String? city,
  }) async {
    state = const RegisterSuccessState();
  }
}
