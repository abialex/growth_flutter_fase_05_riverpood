import 'package:flutter/foundation.dart';

/// Refreshes router redirects when the authentication status changes.
class AuthStateRefreshNotifier extends ChangeNotifier {
  /// Notifies the router that the authentication state changed.
  void refresh() => notifyListeners();
}
