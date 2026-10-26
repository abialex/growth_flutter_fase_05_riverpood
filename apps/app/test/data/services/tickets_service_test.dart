import 'package:flutter_test/flutter_test.dart';
import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/core/supabase/supabase_logger.dart';
import 'package:growth_flutter_fase_05_riverpood/data/services/tickets_service.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/ticket.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/ticket_status.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../helpers/supabase_service_test_support.dart';

Map<String, dynamic> _ticketJson({
  String id = 'ticket-1',
  String status = 'valido',
}) => {
  'id': id,
  'reserva_id': 'reservation-1',
  'codigo': 'ABC-123',
  'estado': status,
  'created_at': '2026-10-20T12:00:00Z',
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

  test('fetchTicketsByReservationIds maps matching tickets', () async {
    const reservationIds = <String>['reservation-1', 'reservation-2'];
    when(
      () => supabaseClient.from('tickets'),
    ).thenAnswer((_) => queryBuilder);
    when(() => queryBuilder.select()).thenAnswer((_) => listBuilder);
    when(
      () => listBuilder.inFilter('reserva_id', reservationIds),
    ).thenAnswer(
      (_) => FakePostgrestFilterBuilder<PostgrestList>([
        _ticketJson(),
      ]),
    );
    final service = TicketsService(
      supabaseClient,
      const SupabaseLogger(),
      failureMapper,
    );

    final result = await service.fetchTicketsByReservationIds(reservationIds);

    expect(
      result,
      isA<Success<List<Ticket>, AppFailure>>().having(
        (success) => success.value,
        'tickets',
        [
          isA<Ticket>()
              .having((ticket) => ticket.id, 'id', 'ticket-1')
              .having((ticket) => ticket.status, 'status', TicketStatus.valid),
        ],
      ),
    );
    verify(() => listBuilder.inFilter('reserva_id', reservationIds)).called(1);
  });

  test(
    'returns no tickets without querying for an empty reservation list',
    () async {
      final service = TicketsService(
        supabaseClient,
        const SupabaseLogger(),
        failureMapper,
      );

      final result = await service.fetchTicketsByReservationIds(const []);

      expect(
        result,
        isA<Success<List<Ticket>, AppFailure>>().having(
          (success) => success.value,
          'tickets',
          isEmpty,
        ),
      );
      verifyNever(() => supabaseClient.from('tickets'));
      verifyNever(() => failureMapper.map(any()));
    },
  );

  test('fetchTicketById filters by ticket id and maps the ticket', () async {
    const ticketId = 'ticket-2';
    when(
      () => supabaseClient.from('tickets'),
    ).thenAnswer((_) => queryBuilder);
    when(() => queryBuilder.select()).thenAnswer((_) => listBuilder);
    when(
      () => listBuilder.eq('id', ticketId),
    ).thenAnswer((_) => listBuilder);
    when(() => listBuilder.maybeSingle()).thenAnswer(
      (_) => FakePostgrestTransformBuilder<Map<String, dynamic>?>(
        _ticketJson(id: ticketId),
      ),
    );
    final service = TicketsService(
      supabaseClient,
      const SupabaseLogger(),
      failureMapper,
    );

    final result = await service.fetchTicketById(ticketId);

    expect(
      result,
      isA<Success<Ticket, AppFailure>>().having(
        (success) => success.value.id,
        'ticket id',
        ticketId,
      ),
    );
    verify(() => listBuilder.eq('id', ticketId)).called(1);
  });

  test(
    'markTicketAsUsed updates the status and returns the updated ticket',
    () async {
      const ticketId = 'ticket-1';
      final updateBuilder = MockPostgrestFilterBuilder<PostgrestList>();
      final transformBuilder = MockPostgrestTransformBuilder<PostgrestList>();
      when(
        () => supabaseClient.from('tickets'),
      ).thenAnswer((_) => queryBuilder);
      when(
        () => queryBuilder.update({'estado': 'usado'}),
      ).thenAnswer((_) => updateBuilder);
      when(
        () => updateBuilder.eq('id', ticketId),
      ).thenAnswer((_) => updateBuilder);
      when(updateBuilder.select).thenAnswer((_) => transformBuilder);
      when(transformBuilder.single).thenAnswer(
        (_) => FakePostgrestTransformBuilder<Map<String, dynamic>>(
          _ticketJson(status: 'usado'),
        ),
      );
      final service = TicketsService(
        supabaseClient,
        const SupabaseLogger(),
        failureMapper,
      );

      final result = await service.markTicketAsUsed(ticketId);

      expect(
        result,
        isA<Success<Ticket, AppFailure>>().having(
          (success) => success.value.status,
          'ticket status',
          TicketStatus.used,
        ),
      );
      verify(() => queryBuilder.update({'estado': 'usado'})).called(1);
      verify(() => updateBuilder.eq('id', ticketId)).called(1);
    },
  );
}
