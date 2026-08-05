import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/tickets_repository_impl.dart';
import '../../data/services/tickets_service.dart';
import '../../domain/repositories/tickets_repository.dart';
import 'core_providers.dart';

final ticketsServiceProvider = Provider<TicketsService>(
  (ref) => TicketsService(ref.watch(supabaseClientProvider)),
);

final ticketsRepositoryProvider = Provider<TicketsRepository>(
  (ref) => TicketsRepositoryImpl(ref.watch(ticketsServiceProvider)),
);
