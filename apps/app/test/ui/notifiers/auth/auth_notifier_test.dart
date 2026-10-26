import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/auth_status.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/auth_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/auth_providers.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  test('resolves an existing session and follows later auth changes', () async {
    final statusController = StreamController<AuthStatus>.broadcast();
    final repository = _MockAuthRepository();
    when(() => repository.authStatusChanges).thenAnswer(
      (_) => statusController.stream,
    );
    when(() => repository.isAuthenticated).thenReturn(true);
    final container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWithValue(repository)],
    );
    final subscription = container.listen(authNotifierProvider, (_, _) {});
    addTearDown(() async {
      subscription.close();
      container.dispose();
      await statusController.close();
    });

    expect(container.read(authNotifierProvider), AuthStatus.loading);
    await Future<void>.delayed(Duration.zero);
    expect(container.read(authNotifierProvider), AuthStatus.authenticated);

    statusController.add(AuthStatus.unauthenticated);
    await Future<void>.delayed(Duration.zero);
    expect(container.read(authNotifierProvider), AuthStatus.unauthenticated);
  });

  test('resolves an absent session as unauthenticated', () async {
    final statusController = StreamController<AuthStatus>.broadcast();
    final repository = _MockAuthRepository();
    when(() => repository.authStatusChanges).thenAnswer(
      (_) => statusController.stream,
    );
    when(() => repository.isAuthenticated).thenReturn(false);
    final container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWithValue(repository)],
    );
    final subscription = container.listen(authNotifierProvider, (_, _) {});
    addTearDown(() async {
      subscription.close();
      container.dispose();
      await statusController.close();
    });

    expect(container.read(authNotifierProvider), AuthStatus.loading);
    await Future<void>.delayed(Duration.zero);
    expect(container.read(authNotifierProvider), AuthStatus.unauthenticated);
  });
}
