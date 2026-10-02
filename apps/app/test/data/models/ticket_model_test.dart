import 'package:flutter_test/flutter_test.dart';
import 'package:growth_flutter_fase_05_riverpood/core/enums/parsing_failure_reason.dart';
import 'package:growth_flutter_fase_05_riverpood/core/errors/parsing_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/data/models/ticket_model.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/ticket.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/ticket_status.dart';

void main() {
  test('maps a valid persisted ticket to the domain entity', () {
    final model = TicketModel.fromJson(_validTicketJson());

    expect(
      model.toEntity(),
      Ticket(
        id: 'ticket-1',
        reservationId: 'reservation-1',
        code: 'TICKET-001',
        status: TicketStatus.valid,
        createdAt: DateTime(2026, 9, 19, 10),
      ),
    );
  });

  test('maps a used ticket status', () {
    final json = _validTicketJson()..['estado'] = 'usado';

    final model = TicketModel.fromJson(json);

    expect(model.status, TicketStatus.used);
  });

  test('reports a required field that is absent from the JSON', () {
    final json = _validTicketJson()..remove('codigo');

    expect(
      () => TicketModel.fromJson(json),
      throwsA(
        isA<ParsingFailure>()
            .having((failure) => failure.field, 'field', 'codigo')
            .having(
              (failure) => failure.reason,
              'reason',
              ParsingFailureReason.missing,
            ),
      ),
    );
  });

  test('rejects an invalid creation date', () {
    final json = _validTicketJson()..['created_at'] = 'not-a-date';

    expect(
      () => TicketModel.fromJson(json),
      throwsA(
        isA<ParsingFailure>()
            .having((failure) => failure.field, 'field', 'created_at')
            .having(
              (failure) => failure.reason,
              'reason',
              ParsingFailureReason.invalidValue,
            ),
      ),
    );
  });
}

Map<String, dynamic> _validTicketJson() {
  return {
    'id': 'ticket-1',
    'reserva_id': 'reservation-1',
    'codigo': 'TICKET-001',
    'estado': 'valido',
    'created_at': '2026-09-19T10:00:00',
  };
}
