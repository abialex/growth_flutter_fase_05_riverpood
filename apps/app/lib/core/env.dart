import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Provides required environment values for the application.
class Env {
  /// The Supabase project URL.
  static String get supabaseUrl => _require('SUPABASE_URL');

  /// The publishable Supabase key.
  static String get supabaseAnonKey => _require('SUPABASE_ANON_KEY');

  static String _require(String variableName) {
    final value = dotenv.env[variableName];
    if (value == null || value.isEmpty) {
      throw StateError('Missing required env variable: $variableName');
    }
    return value;
  }
}
