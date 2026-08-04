import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get supabaseUrl => _require('SUPABASE_URL');

  static String get supabaseAnonKey => _require('SUPABASE_ANON_KEY');

  static String _require(String variableName) {
    final value = dotenv.env[variableName];
    if (value == null || value.isEmpty) {
      throw StateError('Missing required env variable: $variableName');
    }
    return value;
  }
}
