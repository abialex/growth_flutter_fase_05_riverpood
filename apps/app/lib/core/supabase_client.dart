import 'package:growth_flutter_fase_05_riverpood/core/env.dart';
import 'package:growth_flutter_fase_05_riverpood/core/supabase/supabase_logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Initializes the shared Supabase client.
Future<void> initSupabase() async {
  try {
    await Supabase.initialize(
      url: Env.supabaseUrl,
      publishableKey: Env.supabaseAnonKey,
    );
  } on Object catch (exception, stackTrace) {
    const SupabaseLogger().logInitializationError(
      error: exception,
      stackTrace: stackTrace,
    );
    rethrow;
  }
}

/// Returns the initialized Supabase client.
SupabaseClient get supabase => Supabase.instance.client;
