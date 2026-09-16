import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growth_flutter_fase_05_riverpood/core/supabase/supabase_failure_mapper.dart';
import 'package:growth_flutter_fase_05_riverpood/core/supabase/supabase_logger.dart';
import 'package:growth_flutter_fase_05_riverpood/core/supabase_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) => supabase);

final supabaseLoggerProvider = Provider<SupabaseLogger>(
  (_) => const SupabaseLogger(),
);

final supabaseFailureMapperProvider = Provider<SupabaseFailureMapper>(
  (_) => const SupabaseFailureMapper(),
);
