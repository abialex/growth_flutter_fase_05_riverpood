import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:growth_flutter_fase_05_riverpood/data/repositories/auth_repository_impl.dart';
import 'package:growth_flutter_fase_05_riverpood/data/services/auth_service.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/auth_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/login/login_notifier.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/login/login_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/register/register_notifier.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/register/register_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/core_providers.dart';

final authServiceProvider = Provider<AuthService>(
  (ref) => AuthService(ref.watch(supabaseClientProvider)),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(ref.watch(authServiceProvider)),
);

final loginNotifierProvider = NotifierProvider<LoginNotifier, LoginState>(
  LoginNotifier.new,
);

final registerNotifierProvider =
    NotifierProvider<RegisterNotifier, RegisterState>(
      RegisterNotifier.new,
    );
