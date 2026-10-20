import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:growth_flutter_fase_05_riverpood/core/enums/app_failure_type.dart';
import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/errors/failure_mapper.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/core/supabase/supabase_logger.dart';
import 'package:growth_flutter_fase_05_riverpood/data/services/purchase_service.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/ticket.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/ticket_status.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

//todo
class _MockSupabaseClient extends Mock implements SupabaseClient {}

class _MockPostgrestFilterBuilder extends Mock
    implements PostgrestFilterBuilder<Map<String, dynamic>> {}

class _FakePostgrestTransformBuilder extends Fake
    implements PostgrestTransformBuilder<Map<String, dynamic>> {
  _FakePostgrestTransformBuilder(this.value);

  final Map<String, dynamic> value;

  @override
  Future<R> then<R>(
    FutureOr<R> Function(Map<String, dynamic>) onValue, {
    Function? onError,
  }) {
    return Future<Map<String, dynamic>>.value(value).then(
      onValue,
      onError: onError,
    );
  }
}

class _MockFailureMapper extends Mock implements FailureMapper {}

void main() {
  group('PurchaseService.confirmPurchase', () {
    late _MockSupabaseClient supabaseClient;
    late _MockFailureMapper failureMapper;
    late _MockPostgrestFilterBuilder rpcBuilder;

    setUp(() {
      supabaseClient = _MockSupabaseClient();
      failureMapper = _MockFailureMapper();
      rpcBuilder = _MockPostgrestFilterBuilder();
    });

    test(
      'calls the purchase RPC and returns its ticket as a domain entity',
      () async {
        const reservationId = 'reservation-123';
        final createdAt = DateTime.utc(2026, 3, 9);
        final ticket = Ticket(
          id: 'ticket-456',
          reservationId: reservationId,
          code: 'TICKET-ABC',
          status: TicketStatus.valid,
          createdAt: createdAt,
        );

        when(
          () => supabaseClient.rpc<Map<String, dynamic>>(
            'confirmar_compra',
            params: {'p_reserva_id': reservationId},
          ),
        ).thenAnswer((_) => rpcBuilder);
        when(
          () => rpcBuilder.single(),
        ).thenAnswer(
          (_) => _FakePostgrestTransformBuilder({
            'id': ticket.id,
            'reserva_id': reservationId,
            'codigo': ticket.code,
            'estado': 'valido',
            'created_at': createdAt.toIso8601String(),
          }),
        );

        final service = PurchaseService(
          supabaseClient,
          const SupabaseLogger(),
          failureMapper,
        );

        final result = await service.confirmPurchase(reservationId);

        expect(
          result,
          isA<Success<Ticket, AppFailure>>().having(
            (success) => success.value,
            'ticket',
            ticket,
          ),
        );
        verify(
          () => supabaseClient.rpc<Map<String, dynamic>>(
            'confirmar_compra',
            params: {'p_reserva_id': reservationId},
          ),
        ).called(1);
        verify(() => rpcBuilder.single()).called(1);
      },
    );

    test('returns the mapped failure when the purchase RPC fails', () async {
      const reservationId = 'reservation-123';
      const postgrestException = PostgrestException(
        message: 'Reservation has already been purchased',
        code: '23505',
      );
      const expectedFailure = AppFailure(
        failureType: AppFailureType.validation,
        message: 'Ya tienes una reserva para este evento.',
      );

      when(
        () => supabaseClient.rpc<Map<String, dynamic>>(
          'confirmar_compra',
          params: {'p_reserva_id': reservationId},
        ),
      ).thenThrow(postgrestException);
      when(
        () => failureMapper.map(postgrestException),
      ).thenReturn(expectedFailure);

      final service = PurchaseService(
        supabaseClient,
        const SupabaseLogger(),
        failureMapper,
      );

      final result = await service.confirmPurchase(reservationId);

      expect(
        result,
        isA<Failure<Ticket, AppFailure>>().having(
          (failureResult) => failureResult.failure,
          'failure',
          expectedFailure,
        ),
      );
      verify(() => failureMapper.map(postgrestException)).called(1);
    });
  });
}
