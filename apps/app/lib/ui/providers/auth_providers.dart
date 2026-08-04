import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/auth_repository_impl.dart';
import '../../data/services/auth_service.dart';
import '../../domain/repositories/auth_repository.dart';
import '../notifiers/login/login_notifier.dart';
import '../notifiers/login/login_state.dart';
import '../notifiers/register/register_notifier.dart';
import '../notifiers/register/register_state.dart';
import 'core_providers.dart';

final authServiceProvider = Provider<AuthService>(
  (ref) => AuthService(ref.watch(supabaseClientProvider)),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(ref.watch(authServiceProvider)),
);

final loginNotifierProvider = NotifierProvider<LoginNotifier, LoginState>(
  LoginNotifier.new,
);

final registerNotifierProvider = NotifierProvider<RegisterNotifier, RegisterState>(
  RegisterNotifier.new,
);
