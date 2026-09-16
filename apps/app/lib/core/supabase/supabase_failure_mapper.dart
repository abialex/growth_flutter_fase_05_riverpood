import 'package:growth_flutter_fase_05_riverpood/core/enums/app_failure_type.dart';
import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Converts Supabase exceptions into safe application failures.
final class SupabaseFailureMapper {
  /// Creates a Supabase failure mapper.
  const SupabaseFailureMapper();

  /// Maps a PostgREST exception to an application failure.
  AppFailure fromPostgrestException(PostgrestException exception) {
    return AppFailure(
      failureType: _failureTypeFromPostgrestCode(exception.code),
      message: _messageFromPostgrestCode(exception.code),
    );
  }

  /// Maps an authentication exception to an application failure.
  AppFailure fromAuthException(AuthException exception) {
    return AppFailure(
      failureType: exception.statusCode == null
          ? AppFailureType.network
          : AppFailureType.unauthorized,
      message: _messageFromAuthException(exception),
    );
  }

  /// Creates a safe failure for an unexpected transport error.
  AppFailure fromUnexpectedError() {
    return const AppFailure(
      failureType: AppFailureType.unknown,
      message: 'No se pudo completar la operación. Inténtalo nuevamente.',
    );
  }

  AppFailureType _failureTypeFromPostgrestCode(String? code) {
    return switch (code) {
      'PGRST116' => AppFailureType.notFound,
      '42501' => AppFailureType.unauthorized,
      '23505' || 'P0001' => AppFailureType.validation,
      null => AppFailureType.network,
      _ => AppFailureType.server,
    };
  }

  String _messageFromPostgrestCode(String? code) {
    return switch (code) {
      'PGRST116' => 'No se encontró el registro solicitado.',
      '42501' => 'No tienes permisos para realizar esta operación.',
      '23505' => 'Ya tienes una reserva para este evento.',
      'P0001' => 'No se pudo validar la operación.',
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
