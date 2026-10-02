import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/data/repositories/events_repository_impl.dart';
import 'package:growth_flutter_fase_05_riverpood/data/services/events_service.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/events_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/event_detail_data.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/events_data.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/filter_events_use_case.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/load_event_detail_use_case.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/load_events_with_reservation_markers_use_case.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/use_case.dart';
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

final loadEventsWithReservationMarkersUseCaseProvider =
    Provider<UseCase<NoParams, Future<Result<EventsData, AppFailure>>>>(
      (ref) => LoadEventsWithReservationMarkersUseCase(
        eventsRepository: ref.watch(eventsRepositoryProvider),
        reservationsRepository: ref.watch(reservationsRepositoryProvider),
      ),
    );

final filterEventsUseCaseProvider = Provider<FilterEventsUseCase>(
  (_) => const FilterEventsUseCase(),
);

final loadEventDetailUseCaseProvider =
    Provider<UseCase<String, Future<Result<EventDetailData, AppFailure>>>>(
      (ref) => LoadEventDetailUseCase(
        eventsRepository: ref.watch(eventsRepositoryProvider),
        reservationsRepository: ref.watch(reservationsRepositoryProvider),
      ),
    );

final eventsNotifierProvider = NotifierProvider<EventsNotifier, EventsState>(
  EventsNotifier.new,
);

final NotifierProviderFamily<EventDetailNotifier, EventDetailState, String>
eventDetailNotifierProvider =
    NotifierProvider.family<EventDetailNotifier, EventDetailState, String>(
      EventDetailNotifier.new,
    );
