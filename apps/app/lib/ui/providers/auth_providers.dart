import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/login/login_notifier.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/login/login_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/register/register_notifier.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/register/register_state.dart';

final loginNotifierProvider = NotifierProvider<LoginNotifier, LoginState>(
  LoginNotifier.new,
);

final registerNotifierProvider =
    NotifierProvider<RegisterNotifier, RegisterState>(
      RegisterNotifier.new,
    );
