import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:growth_flutter_fase_05_riverpood/data/repositories/tickets_repository_impl.dart';
import 'package:growth_flutter_fase_05_riverpood/data/services/tickets_service.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/tickets_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/core_providers.dart';

final ticketsServiceProvider = Provider<TicketsService>(
  (ref) => TicketsService(
    ref.watch(supabaseClientProvider),
    ref.watch(supabaseLoggerProvider),
    ref.watch(failureMapperProvider),
  ),
);

final ticketsRepositoryProvider = Provider<TicketsRepository>(
  (ref) => TicketsRepositoryImpl(ref.watch(ticketsServiceProvider)),
);
