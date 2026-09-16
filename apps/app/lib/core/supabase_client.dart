import 'package:growth_flutter_fase_05_riverpood/core/env.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> initSupabase() {
  return Supabase.initialize(
    url: Env.supabaseUrl,
    publishableKey: Env.supabaseAnonKey,
  );
}

SupabaseClient get supabase => Supabase.instance.client;
