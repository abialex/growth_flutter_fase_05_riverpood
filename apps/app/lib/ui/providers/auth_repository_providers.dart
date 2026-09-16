import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:growth_flutter_fase_05_riverpood/data/repositories/auth_repository_impl.dart';
import 'package:growth_flutter_fase_05_riverpood/data/services/auth_service.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/auth_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/core_providers.dart';

final authServiceProvider = Provider<AuthService>(
  (ref) => AuthService(
    ref.watch(supabaseClientProvider),
    ref.watch(supabaseLoggerProvider),
    ref.watch(failureMapperProvider),
  ),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(ref.watch(authServiceProvider)),
);
