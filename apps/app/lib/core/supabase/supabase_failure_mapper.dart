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
      failureType: _failureTypeFromAuthException(exception),
      message: _messageFromAuthException(exception),
    );
  }

  AppFailureType _failureTypeFromAuthException(AuthException exception) {
    final statusCode = int.tryParse(exception.statusCode ?? '');
    if (statusCode == null) return AppFailureType.network;

    return switch (exception.code) {
      'invalid_credentials' ||
      'email_not_confirmed' ||
      'user_banned' => AppFailureType.unauthorized,
      'user_already_exists' ||
      'email_exists' ||
      'weak_password' ||
      'email_address_invalid' ||
      'validation_failed' => AppFailureType.validation,
      'signup_disabled' ||
      'email_provider_disabled' ||
      'unexpected_failure' => AppFailureType.server,
      'over_email_send_rate_limit' ||
      'over_request_rate_limit' ||
      'request_timeout' => AppFailureType.network,
      _ when statusCode >= 500 => AppFailureType.server,
      _ => AppFailureType.unauthorized,
    };
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
    final statusCode = int.tryParse(exception.statusCode ?? '');
    if (statusCode == null) {
      return 'No se pudo conectar con el servidor.';
    }

    return switch (exception.code) {
      'invalid_credentials' => 'El correo o la contraseña no son correctos.',
      'email_not_confirmed' => 'Confirma tu correo antes de iniciar sesión.',
      'user_banned' => 'Esta cuenta está temporalmente bloqueada.',
      'user_already_exists' ||
      'email_exists' => 'El correo ya está registrado.',
      'weak_password' => 'La contraseña no cumple los requisitos mínimos.',
      'email_address_invalid' => 'Ingresa una dirección de correo válida.',
      'signup_disabled' || 'email_provider_disabled' =>
        'El registro con correo y contraseña está deshabilitado.',
      'email_address_not_authorized' =>
        'El servicio de correo del proyecto no permite enviar mensajes '
            'a esta dirección.',
      'over_email_send_rate_limit' =>
        'Se enviaron demasiados correos. Espera unos minutos e inténtalo '
            'nuevamente.',
      'over_request_rate_limit' =>
        'Se realizaron demasiados intentos. Espera unos minutos e inténtalo '
            'nuevamente.',
      'request_timeout' =>
        'La autenticación tardó demasiado. Inténtalo nuevamente.',
      'validation_failed' =>
        'Los datos no tienen el formato esperado. Revisa el correo y '
            'la contraseña.',
      'unexpected_failure' =>
        'El servicio de autenticación tuvo un problema. Inténtalo más tarde.',
      _ when statusCode == 429 =>
        'Se realizaron demasiados intentos. Espera unos minutos e inténtalo '
            'nuevamente.',
      _ when statusCode >= 500 =>
        'El servicio de autenticación no está disponible. Inténtalo más tarde.',
      _ => 'No se pudo completar la autenticación.',
    };
  }
}
