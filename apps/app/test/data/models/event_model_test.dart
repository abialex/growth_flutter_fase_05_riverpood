import 'package:flutter_test/flutter_test.dart';
import 'package:growth_flutter_fase_05_riverpood/core/enums/parsing_failure_reason.dart';
import 'package:growth_flutter_fase_05_riverpood/core/errors/parsing_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/data/models/event_model.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/event.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/event_status.dart';

void main() {
  test('maps persisted event fields to the domain entity', () {
    final model = EventModel.fromJson(_validEventJson());

    expect(
      model.toEntity(),
      Event(
        id: 'event-1',
        name: 'Lima Football Match',
        sport: 'football',
        date: DateTime(2026, 9, 19, 10),
        time: '10:00',
        city: 'Lima',
        venue: 'Central Stadium',
        totalSlots: 20,
        availableSlots: 8,
        status: EventStatus.open,
        description: 'Local league match',
      ),
    );
  });

  test('maps an unrecognized persisted status to unknown', () {
    final json = _validEventJson()..['estado'] = 'pospuesto';

    final model = EventModel.fromJson(json);

    expect(model.status, EventStatus.unknown);
  });

  test('reports a missing required field with its persisted name', () {
    final json = _validEventJson()..remove('nombre');

    expect(
      () => EventModel.fromJson(json),
      throwsA(
        isA<ParsingFailure>()
            .having((failure) => failure.field, 'field', 'nombre')
            .having(
              (failure) => failure.reason,
              'reason',
              ParsingFailureReason.missing,
            ),
      ),
    );
  });

  test('rejects a negative available slot count', () {
    final json = _validEventJson()..['cupos_disponibles'] = -1;

    expect(
      () => EventModel.fromJson(json),
      throwsA(
        isA<ParsingFailure>()
            .having(
              (failure) => failure.field,
              'field',
              'cupos_disponibles',
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

Map<String, dynamic> _validEventJson() {
  return {
    'id': 'event-1',
    'nombre': 'Lima Football Match',
    'deporte': 'football',
    'fecha': '2026-09-19T10:00:00',
    'hora': '10:00',
    'ciudad': 'Lima',
    'lugar': 'Central Stadium',
    'cupos_totales': 20,
    'cupos_disponibles': 8,
    'estado': 'abierto',
    'descripcion': 'Local league match',
  };
}
