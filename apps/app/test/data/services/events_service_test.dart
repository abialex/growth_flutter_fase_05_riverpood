import 'package:flutter_test/flutter_test.dart';
import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/core/supabase/supabase_logger.dart';
import 'package:growth_flutter_fase_05_riverpood/data/services/events_service.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/event.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/event_status.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../helpers/supabase_service_test_support.dart';

Map<String, dynamic> _eventJson({String id = 'event-1'}) => {
  'id': id,
  'nombre': 'Football Match',
  'deporte': 'football',
  'fecha': '2026-11-01T10:00:00Z',
  'hora': '10:00',
  'ciudad': 'Lima',
  'lugar': 'Central Stadium',
  'cupos_totales': 20,
  'cupos_disponibles': 18,
  'estado': 'abierto',
  'descripcion': 'Friendly match',
};

void main() {
  late MockSupabaseClient supabaseClient;
  late MockSupabaseQueryBuilder queryBuilder;
  late MockPostgrestFilterBuilder<PostgrestList> listBuilder;
  late MockFailureMapper failureMapper;

  setUp(() {
    supabaseClient = MockSupabaseClient();
    queryBuilder = MockSupabaseQueryBuilder();
    listBuilder = MockPostgrestFilterBuilder<PostgrestList>();
    failureMapper = MockFailureMapper();
  });

  test('fetchEvents orders by date and maps rows to event entities', () async {
    when(
      () => supabaseClient.from('eventos'),
    ).thenAnswer((_) => queryBuilder);
    when(() => queryBuilder.select()).thenAnswer((_) => listBuilder);
    when(
      () => listBuilder.order('fecha', ascending: true),
    ).thenAnswer(
      (_) => FakePostgrestFilterBuilder<PostgrestList>([
        _eventJson(),
      ]),
    );
    final service = EventsService(
      supabaseClient,
      const SupabaseLogger(),
      failureMapper,
    );

    final result = await service.fetchEvents();

    expect(
      result,
      isA<Success<List<Event>, AppFailure>>().having(
        (success) => success.value,
        'events',
        [
          isA<Event>()
              .having((event) => event.id, 'id', 'event-1')
              .having((event) => event.status, 'status', EventStatus.open)
              .having(
                (event) => event.description,
                'description',
                'Friendly match',
              ),
        ],
      ),
    );
    verify(() => supabaseClient.from('eventos')).called(1);
    verify(() => queryBuilder.select()).called(1);
    verify(() => listBuilder.order('fecha', ascending: true)).called(1);
  });

  test('fetchEventById filters by id and maps the row to an event', () async {
    const eventId = 'event-2';
    when(
      () => supabaseClient.from('eventos'),
    ).thenAnswer((_) => queryBuilder);
    when(() => queryBuilder.select()).thenAnswer((_) => listBuilder);
    when(
      () => listBuilder.eq('id', eventId),
    ).thenAnswer((_) => listBuilder);
    when(() => listBuilder.maybeSingle()).thenAnswer(
      (_) => FakePostgrestTransformBuilder<Map<String, dynamic>?>(
        _eventJson(id: eventId),
      ),
    );
    final service = EventsService(
      supabaseClient,
      const SupabaseLogger(),
      failureMapper,
    );

    final result = await service.fetchEventById(eventId);

    expect(
      result,
      isA<Success<Event, AppFailure>>().having(
        (success) => success.value.id,
        'event id',
        eventId,
      ),
    );
    verify(() => listBuilder.eq('id', eventId)).called(1);
    verify(() => listBuilder.maybeSingle()).called(1);
  });
}
