import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:growth_flutter_fase_05_riverpood/core/enums/app_failure_type.dart';
import 'package:growth_flutter_fase_05_riverpood/core/enums/parsing_failure_reason.dart';
import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/errors/failure_mapper.dart';
import 'package:growth_flutter_fase_05_riverpood/core/errors/parsing_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/core/supabase/supabase_crud_service.dart';
import 'package:growth_flutter_fase_05_riverpood/core/supabase/supabase_logger.dart';
import 'package:growth_flutter_fase_05_riverpood/data/models/reservation_with_details_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _MockSupabaseClient extends Mock implements SupabaseClient {}

class _MockSupabaseQueryBuilder extends Mock implements SupabaseQueryBuilder {}

class _MockPostgrestFilterBuilder extends Mock
    implements PostgrestFilterBuilder<PostgrestList> {}

class _MockFailureMapper extends Mock implements FailureMapper {}

class _FakePostgrestFilterBuilder<ResultType> extends Fake
    implements PostgrestFilterBuilder<ResultType> {
  _FakePostgrestFilterBuilder(this.value);

  final ResultType value;

  @override
  Future<R> then<R>(
    FutureOr<R> Function(ResultType) onValue, {
    Function? onError,
  }) {
    return Future<ResultType>.value(value).then(onValue, onError: onError);
  }
}

Map<String, dynamic> _reservationWithDetailsJson() => {
  'reservation_id': 'reservation-1',
  'user_id': 'user-1',
  'event_id': 'event-1',
  'seat_count': 2,
  'reservation_status': 'pendiente',
  'reserved_at': '2026-09-19T09:00:00',
  'event_name': 'Lima Football Match',
  'event_sport': 'football',
  'event_date': '2026-09-19T10:00:00',
  'event_time': '10:00',
  'event_city': 'Lima',
  'event_venue': 'Central Stadium',
  'event_total_slots': 20,
  'event_available_slots': 8,
  'event_description': null,
  'event_status': 'abierto',
};

void main() {
  group('SupabaseCrudService.callRpcList', () {
    late _MockSupabaseClient supabaseClient;
    late _MockFailureMapper failureMapper;

    setUp(() {
      supabaseClient = _MockSupabaseClient();
      failureMapper = _MockFailureMapper();
    });

    test('maps a valid RPC list into reservation detail models', () async {
      const functionName = 'get_my_reservations_with_details';
      const parameters = <String, dynamic>{};
      when(
        () => supabaseClient.rpc<dynamic>(functionName, params: parameters),
      ).thenAnswer(
        (_) => _FakePostgrestFilterBuilder<dynamic>([
          _reservationWithDetailsJson(),
        ]),
      );
      final service = SupabaseCrudService<ReservationWithDetailsModel>(
        supabaseClient: supabaseClient,
        logger: const SupabaseLogger(),
        failureMapper: failureMapper,
        tableName: 'reservas',
        fromJson: ReservationWithDetailsModel.fromJson,
      );

      final result = await service.callRpcList<ReservationWithDetailsModel>(
        functionName: functionName,
        parameters: parameters,
        fromJson: ReservationWithDetailsModel.fromJson,
      );

      expect(
        result,
        isA<Success<List<ReservationWithDetailsModel>, AppFailure>>()
            .having((success) => success.value, 'row count', hasLength(1))
            .having(
              (success) => success.value.single.reservation.id,
              'reservation id',
              'reservation-1',
            )
            .having(
              (success) => success.value.single.event.name,
              'event name',
              'Lima Football Match',
            ),
      );
      verify(
        () => supabaseClient.rpc<dynamic>(functionName, params: parameters),
      ).called(1);
    });

    test('maps a malformed RPC row to an application failure', () async {
      const functionName = 'get_my_reservations_with_details';
      const parameters = <String, dynamic>{};
      const expectedFailure = AppFailure(
        failureType: AppFailureType.server,
        message: 'Los datos recibidos no son válidos. Inténtalo nuevamente.',
      );
      when(
        () => supabaseClient.rpc<dynamic>(functionName, params: parameters),
      ).thenAnswer(
        (_) => _FakePostgrestFilterBuilder<dynamic>([42]),
      );
      when(() => failureMapper.map(any())).thenReturn(expectedFailure);
      final service = SupabaseCrudService<ReservationWithDetailsModel>(
        supabaseClient: supabaseClient,
        logger: const SupabaseLogger(),
        failureMapper: failureMapper,
        tableName: 'reservas',
        fromJson: ReservationWithDetailsModel.fromJson,
      );

      final result = await service.callRpcList<ReservationWithDetailsModel>(
        functionName: functionName,
        parameters: parameters,
        fromJson: ReservationWithDetailsModel.fromJson,
      );

      expect(
        result,
        isA<Failure<List<ReservationWithDetailsModel>, AppFailure>>().having(
          (failureResult) => failureResult.failure,
          'failure',
          same(expectedFailure),
        ),
      );
      final mappedError = verify(
        () => failureMapper.map(captureAny()),
      ).captured.single;
      expect(
        mappedError,
        isA<ParsingFailure>()
            .having(
              (failure) => failure.field,
              'field',
              '$functionName[0]',
            )
            .having(
              (failure) => failure.reason,
              'reason',
              ParsingFailureReason.invalidType,
            ),
      );
    });
  });

  group('SupabaseCrudService.fetchById', () {
    late _MockSupabaseClient supabaseClient;
    late _MockSupabaseQueryBuilder queryBuilder;
    late _MockPostgrestFilterBuilder filterBuilder;
    late _MockFailureMapper failureMapper;

    setUp(() {
      supabaseClient = _MockSupabaseClient();
      queryBuilder = _MockSupabaseQueryBuilder();
      filterBuilder = _MockPostgrestFilterBuilder();
      failureMapper = _MockFailureMapper();
    });

    test('maps a missing row to a not-found application failure', () async {
      const recordId = 'reservation-missing';
      const expectedFailure = AppFailure(
        failureType: AppFailureType.notFound,
        message: 'No encontramos la reserva solicitada.',
      );
      when(
        () => supabaseClient.from('reservas'),
      ).thenAnswer((_) => queryBuilder);
      when(
        () => queryBuilder.select(),
      ).thenAnswer((_) => filterBuilder);
      when(
        () => filterBuilder.eq('id', recordId),
      ).thenAnswer((_) => filterBuilder);
      when(
        () => filterBuilder.maybeSingle(),
      ).thenAnswer(
        (_) => _FakePostgrestFilterBuilder<Map<String, dynamic>?>(null),
      );
      when(() => failureMapper.map(any())).thenReturn(expectedFailure);
      final service = SupabaseCrudService<ReservationWithDetailsModel>(
        supabaseClient: supabaseClient,
        logger: const SupabaseLogger(),
        failureMapper: failureMapper,
        tableName: 'reservas',
        fromJson: ReservationWithDetailsModel.fromJson,
      );

      final result = await service.fetchById(recordId);

      expect(
        result,
        isA<Failure<ReservationWithDetailsModel, AppFailure>>().having(
          (failureResult) => failureResult.failure,
          'failure',
          same(expectedFailure),
        ),
      );
      final mappedError = verify(
        () => failureMapper.map(captureAny()),
      ).captured.single;
      expect(
        mappedError,
        isA<PostgrestException>()
            .having((error) => error.code, 'code', 'PGRST116')
            .having(
              (error) => error.message,
              'message',
              'No row found in reservas for id=$recordId',
            ),
      );
      verify(() => supabaseClient.from('reservas')).called(1);
      verify(() => queryBuilder.select()).called(1);
      verify(() => filterBuilder.eq('id', recordId)).called(1);
      verify(() => filterBuilder.maybeSingle()).called(1);
    });
  });

  group('SupabaseCrudService.fetchWhereIn', () {
    late _MockSupabaseClient supabaseClient;
    late _MockSupabaseQueryBuilder queryBuilder;
    late _MockPostgrestFilterBuilder filterBuilder;
    late _MockFailureMapper failureMapper;

    setUp(() {
      supabaseClient = _MockSupabaseClient();
      queryBuilder = _MockSupabaseQueryBuilder();
      filterBuilder = _MockPostgrestFilterBuilder();
      failureMapper = _MockFailureMapper();
    });

    test('returns an empty success without querying Supabase', () async {
      final service = SupabaseCrudService<ReservationWithDetailsModel>(
        supabaseClient: supabaseClient,
        logger: const SupabaseLogger(),
        failureMapper: failureMapper,
        tableName: 'reservas',
        fromJson: ReservationWithDetailsModel.fromJson,
      );

      final result = await service.fetchWhereIn('event_id', const <Object>[]);

      expect(
        result,
        isA<Success<List<ReservationWithDetailsModel>, AppFailure>>().having(
          (success) => success.value,
          'records',
          isEmpty,
        ),
      );
      verifyNever(() => supabaseClient.from('reservas'));
      verifyNever(() => failureMapper.map(any()));
    });

    test('filters by the provided values and maps the matching rows', () async {
      const columnName = 'event_id';
      const columnValues = <Object>['event-1', 'event-2'];
      when(
        () => supabaseClient.from('reservas'),
      ).thenAnswer((_) => queryBuilder);
      when(
        () => queryBuilder.select(),
      ).thenAnswer((_) => filterBuilder);
      when(
        () => filterBuilder.inFilter(columnName, columnValues),
      ).thenAnswer(
        (_) => _FakePostgrestFilterBuilder<PostgrestList>([
          _reservationWithDetailsJson(),
        ]),
      );
      final service = SupabaseCrudService<ReservationWithDetailsModel>(
        supabaseClient: supabaseClient,
        logger: const SupabaseLogger(),
        failureMapper: failureMapper,
        tableName: 'reservas',
        fromJson: ReservationWithDetailsModel.fromJson,
      );

      final result = await service.fetchWhereIn(columnName, columnValues);

      expect(
        result,
        isA<Success<List<ReservationWithDetailsModel>, AppFailure>>()
            .having((success) => success.value, 'row count', hasLength(1))
            .having(
              (success) => success.value.single.reservation.id,
              'reservation id',
              'reservation-1',
            ),
      );
      verify(() => supabaseClient.from('reservas')).called(1);
      verify(() => queryBuilder.select()).called(1);
      verify(() => filterBuilder.inFilter(columnName, columnValues)).called(1);
    });
  });

  group('SupabaseCrudService.fetchWhere', () {
    late _MockSupabaseClient supabaseClient;
    late _MockSupabaseQueryBuilder queryBuilder;
    late _MockPostgrestFilterBuilder filterBuilder;
    late _MockFailureMapper failureMapper;

    setUp(() {
      supabaseClient = _MockSupabaseClient();
      queryBuilder = _MockSupabaseQueryBuilder();
      filterBuilder = _MockPostgrestFilterBuilder();
      failureMapper = _MockFailureMapper();
    });

    test('filters by a column value and maps the matching rows', () async {
      const columnName = 'event_id';
      const columnValue = 'event-1';
      when(
        () => supabaseClient.from('reservas'),
      ).thenAnswer((_) => queryBuilder);
      when(
        () => queryBuilder.select(),
      ).thenAnswer((_) => filterBuilder);
      when(
        () => filterBuilder.eq(columnName, columnValue),
      ).thenAnswer(
        (_) => _FakePostgrestFilterBuilder<PostgrestList>([
          _reservationWithDetailsJson(),
        ]),
      );
      final service = SupabaseCrudService<ReservationWithDetailsModel>(
        supabaseClient: supabaseClient,
        logger: const SupabaseLogger(),
        failureMapper: failureMapper,
        tableName: 'reservas',
        fromJson: ReservationWithDetailsModel.fromJson,
      );

      final result = await service.fetchWhere(columnName, columnValue);

      expect(
        result,
        isA<Success<List<ReservationWithDetailsModel>, AppFailure>>()
            .having((success) => success.value, 'row count', hasLength(1))
            .having(
              (success) => success.value.single.reservation.id,
              'reservation id',
              'reservation-1',
            ),
      );
      verify(() => supabaseClient.from('reservas')).called(1);
      verify(() => queryBuilder.select()).called(1);
      verify(() => filterBuilder.eq(columnName, columnValue)).called(1);
    });
  });

  group('SupabaseCrudService.fetchAll', () {
    late _MockSupabaseClient supabaseClient;
    late _MockSupabaseQueryBuilder queryBuilder;
    late _MockPostgrestFilterBuilder filterBuilder;
    late _MockFailureMapper failureMapper;

    setUp(() {
      supabaseClient = _MockSupabaseClient();
      queryBuilder = _MockSupabaseQueryBuilder();
      filterBuilder = _MockPostgrestFilterBuilder();
      failureMapper = _MockFailureMapper();
    });

    test('orders and limits rows before mapping them', () async {
      const orderByColumn = 'reserved_at';
      const limitCount = 5;
      when(
        () => supabaseClient.from('reservas'),
      ).thenAnswer((_) => queryBuilder);
      when(
        () => queryBuilder.select(),
      ).thenAnswer((_) => filterBuilder);
      when(
        () => filterBuilder.order(orderByColumn, ascending: true),
      ).thenAnswer((_) => filterBuilder);
      when(
        () => filterBuilder.limit(limitCount),
      ).thenAnswer(
        (_) => _FakePostgrestFilterBuilder<PostgrestList>([
          _reservationWithDetailsJson(),
        ]),
      );
      final service = SupabaseCrudService<ReservationWithDetailsModel>(
        supabaseClient: supabaseClient,
        logger: const SupabaseLogger(),
        failureMapper: failureMapper,
        tableName: 'reservas',
        fromJson: ReservationWithDetailsModel.fromJson,
      );

      final result = await service.fetchAll(
        orderByColumn: orderByColumn,
        ascending: true,
        limitCount: limitCount,
      );

      expect(
        result,
        isA<Success<List<ReservationWithDetailsModel>, AppFailure>>()
            .having((success) => success.value, 'row count', hasLength(1))
            .having(
              (success) => success.value.single.reservation.id,
              'reservation id',
              'reservation-1',
            ),
      );
      verify(() => supabaseClient.from('reservas')).called(1);
      verify(() => queryBuilder.select()).called(1);
      verify(
        () => filterBuilder.order(orderByColumn, ascending: true),
      ).called(1);
      verify(() => filterBuilder.limit(limitCount)).called(1);
    });
  });
}
