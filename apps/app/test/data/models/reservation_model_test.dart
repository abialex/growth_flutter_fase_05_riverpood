import 'package:flutter_test/flutter_test.dart';
import 'package:growth_flutter_fase_05_riverpood/core/enums/parsing_failure_reason.dart';
import 'package:growth_flutter_fase_05_riverpood/core/errors/parsing_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/data/models/reservation_model.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/reservation.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/reservation_status.dart';

void main() {
  test('maps persisted reservation fields to the domain entity', () {
    final model = ReservationModel.fromJson(_validReservationJson());

    expect(
      model.toEntity(),
      Reservation(
        id: 'reservation-1',
        userId: 'user-1',
        eventId: 'event-1',
        seatCount: 2,
        status: ReservationStatus.confirmed,
        reservedAt: DateTime(2026, 9, 19, 9),
      ),
    );
  });

  test('reports a required field that is absent from the JSON', () {
    final json = _validReservationJson()..remove('evento_id');

    expect(
      () => ReservationModel.fromJson(json),
      throwsA(
        isA<ParsingFailure>()
            .having((failure) => failure.field, 'field', 'evento_id')
            .having(
              (failure) => failure.reason,
              'reason',
              ParsingFailureReason.missing,
            ),
      ),
    );
  });

  test('rejects a reservation with zero seats', () {
    final json = _validReservationJson()..['cantidad_cupos'] = 0;

    expect(
      () => ReservationModel.fromJson(json),
      throwsA(
        isA<ParsingFailure>()
            .having(
              (failure) => failure.field,
              'field',
              'cantidad_cupos',
            )
            .having(
              (failure) => failure.reason,
              'reason',
              ParsingFailureReason.invalidValue,
            ),
      ),
    );
  });
}

Map<String, dynamic> _validReservationJson() {
  return {
    'id': 'reservation-1',
    'usuario_id': 'user-1',
    'evento_id': 'event-1',
    'cantidad_cupos': 2,
    'estado': 'confirmada',
    'fecha_reserva': '2026-09-19T09:00:00',
  };
}
