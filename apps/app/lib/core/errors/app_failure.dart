import 'package:supabase_flutter/supabase_flutter.dart';

import '../enums/app_failure_type.dart';

class AppFailure {
  const AppFailure({
    required this.failureType,
    required this.message,
    this.originalException,
  });

  factory AppFailure.fromPostgrestException(PostgrestException exception) {
    final message = exception.code == '23505'
        ? 'Ya tienes una reserva para este evento.'
        : exception.message;
    return AppFailure(
      failureType: _failureTypeFromPostgrestCode(exception.code),
      message: message,
      originalException: exception,
    );
  }

  factory AppFailure.fromAuthException(AuthException exception) {
    return AppFailure(
      failureType: AppFailureType.unauthorized,
      message: exception.message,
      originalException: exception,
    );
  }

  factory AppFailure.unknown(Object exception) {
    return AppFailure(
      failureType: AppFailureType.unknown,
      message: exception.toString(),
      originalException: exception,
    );
  }

  final AppFailureType failureType;
  final String message;
  final Object? originalException;

  static AppFailureType _failureTypeFromPostgrestCode(String? code) {
    switch (code) {
      case 'PGRST116':
        return AppFailureType.notFound;
      case '42501':
        return AppFailureType.unauthorized;
      case '23505':
        return AppFailureType.validation;
      case 'P0001':
        return AppFailureType.validation;
      case null:
        return AppFailureType.network;
      default:
        return AppFailureType.server;
    }
  }
}
