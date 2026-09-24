import 'package:growth_flutter_fase_05_riverpood/core/enums/app_failure_type.dart';
import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/errors/failure_mapper.dart';
import 'package:growth_flutter_fase_05_riverpood/core/errors/parsing_failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Converts Supabase exceptions into safe application failures.
final class SupabaseFailureMapper implements FailureMapper {
  /// Creates a Supabase failure mapper.
  const SupabaseFailureMapper();

  @override
  AppFailure map(Object error) {
    if (error is PostgrestException) {
      return _fromPostgrestException(error);
    }
    if (error is AuthException) {
      return _fromAuthException(error);
    }
    if (error is ParsingFailure) {
      return _fromParsingFailure(error);
    }
    return _fromUnexpectedError();
  }

  AppFailure _fromPostgrestException(PostgrestException exception) {
    return AppFailure(
      failureType: _failureTypeFromPostgrestCode(exception.code),
      message: _messageFromPostgrestCode(exception.code),
    );
  }

  AppFailure _fromAuthException(AuthException exception) {
    return AppFailure(
      failureType: exception.statusCode == null
          ? AppFailureType.network
          : AppFailureType.unauthorized,
      message: _messageFromAuthException(exception),
    );
  }

  AppFailure _fromParsingFailure(ParsingFailure failure) {
    return const AppFailure(
      failureType: AppFailureType.server,
      message: 'Los datos recibidos no son válidos. Inténtalo nuevamente.',
    );
  }

  AppFailure _fromUnexpectedError() {
    return const AppFailure(
      failureType: AppFailureType.unknown,
      message: 'No se pudo completar la operación. Inténtalo nuevamente.',
    );
  }

  AppFailureType _failureTypeFromPostgrestCode(String? code) {
    return switch (code) {
      'PGRST116' => AppFailureType.notFound,
      '42501' => AppFailureType.unauthorized,
      '23505' ||
      'P0001' ||
      'P0003' ||
      'P0004' ||
      'P0005' => AppFailureType.validation,
      'P0002' || 'P0006' => AppFailureType.notFound,
      null => AppFailureType.network,
      _ => AppFailureType.server,
    };
  }

  String _messageFromPostgrestCode(String? code) {
    return switch (code) {
      'PGRST116' => 'No se encontró el registro solicitado.',
      '42501' => 'No tienes permisos para realizar esta operación.',
      '23505' => 'Ya tienes una reserva para este evento.',
      'P0001' => 'La cantidad de cupos solicitada no es válida.',
      'P0002' => 'El evento no existe.',
      'P0003' => 'El evento ya no está disponible para reservas.',
      'P0004' => 'No hay suficientes cupos disponibles.',
      'P0005' => 'La reserva no se puede confirmar en su estado actual.',
      'P0006' => 'La reserva no existe o no te pertenece.',
      null => 'No se pudo conectar con el servidor.',
      _ => 'No se pudo completar la operación con el servidor.',
    };
  }

  String _messageFromAuthException(AuthException exception) {
    if (exception.statusCode == null) {
      return 'No se pudo conectar con el servidor.';
    }

    return switch (exception.code) {
      'invalid_credentials' => 'El correo o la contraseña no son correctos.',
      'user_already_exists' ||
      'email_exists' => 'El correo ya está registrado.',
      'weak_password' => 'La contraseña no cumple los requisitos mínimos.',
      _ => 'No se pudo completar la autenticación.',
    };
  }
}
