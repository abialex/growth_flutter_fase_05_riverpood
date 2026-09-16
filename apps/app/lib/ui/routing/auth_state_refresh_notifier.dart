import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:growth_flutter_fase_05_riverpood/domain/enums/auth_status.dart';

/// Refreshes router redirects when the authentication status changes.
class AuthStateRefreshNotifier extends ChangeNotifier {
  /// Subscribes to authentication status changes.
  AuthStateRefreshNotifier(Stream<AuthStatus> authStatusChanges) {
    _subscription = authStatusChanges.listen((_) => notifyListeners());
  }

  late final StreamSubscription<AuthStatus> _subscription;

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}
