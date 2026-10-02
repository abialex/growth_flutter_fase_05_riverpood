import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:growth_flutter_fase_05_riverpood/core/enums/app_failure_type.dart';
import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/event.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/event_status.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/event_detail_data.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/use_case.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/event_detail/event_detail_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/event_detail/states/event_detail_error_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/event_detail/states/event_detail_loaded_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/event_detail/states/event_detail_loading_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/event_providers.dart';
import 'package:mocktail/mocktail.dart';

Event _createEvent({String id = 'event-1', String name = 'Football Match'}) {
  return Event(
    id: id,
    name: name,
    sport: 'football',
    date: DateTime(2026, 9, 19),
    time: '10:00',
    city: 'Lima',
    venue: 'Central Stadium',
    totalSlots: 20,
    availableSlots: 10,
    status: EventStatus.open,
  );
}

class _MockLoadEventDetail extends Mock
    implements UseCase<String, Future<Result<EventDetailData, AppFailure>>> {}

void main() {
  test('shows loading and then the failure returned by the use case', () async {
    const eventId = 'event-1';
    const failure = AppFailure(
      failureType: AppFailureType.network,
      message: 'Network unavailable',
    );
    final response = Completer<Result<EventDetailData, AppFailure>>();
    final useCase = _MockLoadEventDetail();
    when(() => useCase.call(eventId)).thenAnswer((_) => response.future);
    final container = ProviderContainer(
      overrides: [loadEventDetailUseCaseProvider.overrideWithValue(useCase)],
    );
    addTearDown(container.dispose);
    final detailProvider = eventDetailNotifierProvider(eventId);
    final observedStates = <EventDetailState>[];
    final subscription = container.listen(detailProvider, (_, state) {
      observedStates.add(state);
    });
    addTearDown(subscription.close);

    expect(container.read(detailProvider), isA<EventDetailLoadingState>());

    response.complete(const Failure<EventDetailData, AppFailure>(failure));
    await Future<void>.delayed(Duration.zero);

    final state = container.read(detailProvider);
    expect(state, isA<EventDetailErrorState>());
    expect((state as EventDetailErrorState).failure, same(failure));
    expect(observedStates, hasLength(1));
    expect(observedStates.single, isA<EventDetailErrorState>());
    verify(() => useCase.call(eventId)).called(1);
  });

  test('recovers from the initial failure when retried', () async {
    const eventId = 'event-1';
    const failure = AppFailure(
      failureType: AppFailureType.network,
      message: 'Network unavailable',
    );
    final event = _createEvent();
    final results = <Result<EventDetailData, AppFailure>>[
      const Failure<EventDetailData, AppFailure>(failure),
      Success(EventDetailData(event: event)),
    ];
    final useCase = _MockLoadEventDetail();
    when(
      () => useCase.call(eventId),
    ).thenAnswer((_) async => results.removeAt(0));
    final container = ProviderContainer(
      overrides: [loadEventDetailUseCaseProvider.overrideWithValue(useCase)],
    );
    addTearDown(container.dispose);
    final detailProvider = eventDetailNotifierProvider(eventId);
    final notifier = container.read(detailProvider.notifier);

    expect(container.read(detailProvider), isA<EventDetailLoadingState>());
    await Future<void>.delayed(Duration.zero);
    expect(container.read(detailProvider), isA<EventDetailErrorState>());

    final retry = notifier.onRetry();
    expect(container.read(detailProvider), isA<EventDetailLoadingState>());
    await retry;

    final state = container.read(detailProvider);
    expect(state, isA<EventDetailLoadedState>());
    expect((state as EventDetailLoadedState).event, same(event));
    verify(() => useCase.call(eventId)).called(2);
  });

  test('ignores the initial result when a retry finishes first', () async {
    const eventId = 'event-1';
    final olderEvent = _createEvent(name: 'Older event data');
    final newerEvent = _createEvent(name: 'Latest event data');
    final initialResponse = Completer<Result<EventDetailData, AppFailure>>();
    final retryResponse = Completer<Result<EventDetailData, AppFailure>>();
    final responses = [initialResponse, retryResponse];
    final useCase = _MockLoadEventDetail();
    when(() => useCase.call(eventId)).thenAnswer(
      (_) => responses.removeAt(0).future,
    );
    final container = ProviderContainer(
      overrides: [loadEventDetailUseCaseProvider.overrideWithValue(useCase)],
    );
    addTearDown(container.dispose);
    final notifier = container.read(
      eventDetailNotifierProvider(eventId).notifier,
    );

    final retry = notifier.onRetry();

    retryResponse.complete(
      Success(EventDetailData(event: newerEvent)),
    );
    await retry;
    initialResponse.complete(
      Success(EventDetailData(event: olderEvent)),
    );
    await Future<void>.delayed(Duration.zero);

    final state = container.read(eventDetailNotifierProvider(eventId));
    expect(state, isA<EventDetailLoadedState>());
    expect((state as EventDetailLoadedState).event, same(newerEvent));
    verify(() => useCase.call(eventId)).called(2);
  });
}
