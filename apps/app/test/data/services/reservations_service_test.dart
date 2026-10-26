import 'package:flutter_test/flutter_test.dart';
import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/core/supabase/supabase_logger.dart';
import 'package:growth_flutter_fase_05_riverpood/data/services/reservations_service.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/reservation.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/reservation_with_details.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/event_status.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/reservation_status.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../helpers/supabase_service_test_support.dart';

Map<String, dynamic> _reservationJson() => {
  'id': 'reservation-1',
  'usuario_id': 'user-1',
  'evento_id': 'event-1',
  'cantidad_cupos': 2,
  'estado': 'pendiente',
  'fecha_reserva': '2026-10-20T12:00:00Z',
};

Map<String, dynamic> _reservationWithDetailsJson() => {
  'reservation_id': 'reservation-1',
  'user_id': 'user-1',
  'event_id': 'event-1',
  'seat_count': 2,
  'reservation_status': 'pendiente',
  'reserved_at': '2026-10-20T12:00:00Z',
  'event_name': 'Football Match',
  'event_sport': 'football',
  'event_date': '2026-11-01T10:00:00Z',
  'event_time': '10:00',
  'event_city': 'Lima',
  'event_venue': 'Central Stadium',
  'event_total_slots': 20,
  'event_available_slots': 18,
  'event_description': null,
  'event_status': 'abierto',
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

  test('createReservation calls the RPC and maps its response', () async {
    const eventId = 'event-1';
    const seatCount = 2;
    final reservedAt = DateTime.utc(2026, 10, 20, 12);
    final rpcBuilder = MockPostgrestFilterBuilder<Map<String, dynamic>>();
    when(
      () => supabaseClient.rpc<Map<String, dynamic>>(
        'crear_reserva',
        params: {
          'p_evento_id': eventId,
          'p_cantidad_cupos': seatCount,
        },
      ),
    ).thenAnswer((_) => rpcBuilder);
    when(rpcBuilder.single).thenAnswer(
      (_) => FakePostgrestTransformBuilder<Map<String, dynamic>>({
        ..._reservationJson(),
        'fecha_reserva': reservedAt.toIso8601String(),
      }),
    );
    final service = ReservationsService(
      supabaseClient,
      const SupabaseLogger(),
      failureMapper,
    );

    final result = await service.createReservation(
      eventId: eventId,
      seatCount: seatCount,
    );

    expect(
      result,
      isA<Success<Reservation, AppFailure>>().having(
        (success) => success.value,
        'reservation',
        isA<Reservation>()
            .having((reservation) => reservation.id, 'id', 'reservation-1')
            .having(
              (reservation) => reservation.status,
              'status',
              ReservationStatus.pending,
            ),
      ),
    );
    verify(
      () => supabaseClient.rpc<Map<String, dynamic>>(
        'crear_reserva',
        params: {
          'p_evento_id': eventId,
          'p_cantidad_cupos': seatCount,
        },
      ),
    ).called(1);
  });

  test(
    'fetchMyReservations orders rows and maps them to reservation entities',
    () async {
      when(
        () => supabaseClient.from('reservas'),
      ).thenAnswer((_) => queryBuilder);
      when(() => queryBuilder.select()).thenAnswer((_) => listBuilder);
      when(
        () => listBuilder.order('fecha_reserva'),
      ).thenAnswer(
        (_) => FakePostgrestFilterBuilder<PostgrestList>([
          _reservationJson(),
        ]),
      );
      final service = ReservationsService(
        supabaseClient,
        const SupabaseLogger(),
        failureMapper,
      );

      final result = await service.fetchMyReservations();

      expect(
        result,
        isA<Success<List<Reservation>, AppFailure>>().having(
          (success) => success.value,
          'reservations',
          [
            isA<Reservation>()
                .having((reservation) => reservation.id, 'id', 'reservation-1')
                .having(
                  (reservation) => reservation.seatCount,
                  'seat count',
                  2,
                ),
          ],
        ),
      );
      verify(() => supabaseClient.from('reservas')).called(1);
      verify(() => listBuilder.order('fecha_reserva')).called(1);
    },
  );

  test(
    'fetchMyReservationsWithDetails calls the RPC and maps related entities',
    () async {
      when(
        () => supabaseClient.rpc<dynamic>(
          'get_my_reservations_with_details',
          params: const <String, dynamic>{},
        ),
      ).thenAnswer(
        (_) => FakePostgrestFilterBuilder<dynamic>([
          _reservationWithDetailsJson(),
        ]),
      );
      final service = ReservationsService(
        supabaseClient,
        const SupabaseLogger(),
        failureMapper,
      );

      final result = await service.fetchMyReservationsWithDetails();

      expect(
        result,
        isA<Success<List<ReservationWithDetails>, AppFailure>>().having(
          (success) => success.value,
          'reservation details',
          [
            isA<ReservationWithDetails>()
                .having(
                  (details) => details.reservation.id,
                  'reservation id',
                  'reservation-1',
                )
                .having(
                  (details) => details.event.status,
                  'event status',
                  EventStatus.open,
                ),
          ],
        ),
      );
      verify(
        () => supabaseClient.rpc<dynamic>(
          'get_my_reservations_with_details',
          params: const <String, dynamic>{},
        ),
      ).called(1);
    },
  );
}
