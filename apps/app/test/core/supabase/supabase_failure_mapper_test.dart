import 'package:flutter_test/flutter_test.dart';
import 'package:growth_flutter_fase_05_riverpood/core/enums/app_failure_type.dart';
import 'package:growth_flutter_fase_05_riverpood/core/enums/parsing_failure_reason.dart';
import 'package:growth_flutter_fase_05_riverpood/core/errors/parsing_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/supabase/supabase_failure_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  const mapper = SupabaseFailureMapper();

  test('maps a duplicate reservation error to a validation failure', () {
    final failure = mapper.map(
      const PostgrestException(
        message: 'duplicate row contains private data',
        code: '23505',
        details: 'private reservation payload',
        hint: 'internal database hint',
      ),
    );

    expect(failure.failureType, AppFailureType.validation);
    expect(failure.message, 'Ya tienes una reserva para este evento.');
    expect(failure.message, isNot(contains('private')));
  });

  test('maps invalid credentials to an unauthorized failure', () {
    final failure = mapper.map(
      const AuthException(
        'sensitive provider response',
        statusCode: '400',
        code: 'invalid_credentials',
      ),
    );

    expect(failure.failureType, AppFailureType.unauthorized);
    expect(failure.message, 'El correo o la contraseña no son correctos.');
    expect(failure.message, isNot(contains('sensitive')));
  });

  test('maps parsing failures to a safe server message', () {
    final failure = mapper.map(
      const ParsingFailure(
        field: 'codigo_privado',
        reason: ParsingFailureReason.invalidType,
        expectedType: 'String',
        actualType: 'int',
      ),
    );

    expect(failure.failureType, AppFailureType.server);
    expect(
      failure.message,
      'Los datos recibidos no son válidos. Inténtalo nuevamente.',
    );
    expect(failure.message, isNot(contains('codigo_privado')));
  });

  test('maps unexpected errors without exposing their details', () {
    final failure = mapper.map(Exception('private token value'));

    expect(failure.failureType, AppFailureType.unknown);
    expect(
      failure.message,
      'No se pudo completar la operación. Inténtalo nuevamente.',
    );
    expect(failure.message, isNot(contains('private token value')));
  });
}
