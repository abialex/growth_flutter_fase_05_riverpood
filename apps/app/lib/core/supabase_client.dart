import 'package:supabase_flutter/supabase_flutter.dart';

import 'env.dart';

Future<void> initSupabase() {
  return Supabase.initialize(
    url: Env.supabaseUrl,
    publishableKey: Env.supabaseAnonKey,
  );
}

SupabaseClient get supabase => Supabase.instance.client;
