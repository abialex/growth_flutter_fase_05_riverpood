import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/supabase_client.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) => supabase);
