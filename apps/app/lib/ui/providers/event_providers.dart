import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:growth_flutter_fase_05_riverpood/data/repositories/events_repository_impl.dart';
import 'package:growth_flutter_fase_05_riverpood/data/services/events_service.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/events_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/load_event_detail_use_case.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/load_events_use_case.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/event_detail/event_detail_notifier.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/event_detail/event_detail_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/events/events_notifier.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/events/events_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/core_providers.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/reservation_providers.dart';

final eventsServiceProvider = Provider<EventsService>(
  (ref) => EventsService(
    ref.watch(supabaseClientProvider),
    ref.watch(supabaseLoggerProvider),
    ref.watch(failureMapperProvider),
  ),
);

final eventsRepositoryProvider = Provider<EventsRepository>(
  (ref) => EventsRepositoryImpl(ref.watch(eventsServiceProvider)),
);

final loadEventsUseCaseProvider = Provider<LoadEventsUseCase>(
  (ref) => LoadEventsUseCase(
    eventsRepository: ref.watch(eventsRepositoryProvider),
    reservationsRepository: ref.watch(reservationsRepositoryProvider),
  ),
);

final loadEventDetailUseCaseProvider = Provider<LoadEventDetailUseCase>(
  (ref) => LoadEventDetailUseCase(
    eventsRepository: ref.watch(eventsRepositoryProvider),
    reservationsRepository: ref.watch(reservationsRepositoryProvider),
  ),
);

final eventsNotifierProvider = NotifierProvider<EventsNotifier, EventsState>(
  EventsNotifier.new,
);

final eventDetailNotifierProvider =
    NotifierProvider<EventDetailNotifier, EventDetailState>(
      EventDetailNotifier.new,
    );
