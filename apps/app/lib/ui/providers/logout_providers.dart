import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/logout/logout_notifier.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/logout/logout_state.dart';

/// Provides the notifier that handles logout.
final logoutNotifierProvider = NotifierProvider<LogoutNotifier, LogoutState>(
  LogoutNotifier.new,
);
