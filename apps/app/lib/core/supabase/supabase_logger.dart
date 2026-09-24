import 'dart:developer' as developer;

import 'package:growth_flutter_fase_05_riverpood/core/errors/parsing_failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Writes safe Supabase diagnostics to the Dart developer log.
class SupabaseLogger {
  /// Creates a Supabase logger.
  const SupabaseLogger();

  /// Logs an error raised while initializing Supabase.
  void logInitializationError({
    required Object error,
    required StackTrace stackTrace,
  }) {
    _log(
      message: 'Supabase initialization failed.',
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Logs an error raised by a PostgREST operation.
  void logPostgrestError({
    required String operation,
    required String tableName,
    required PostgrestException exception,
    required StackTrace stackTrace,
  }) {
    _log(
      message:
          'Supabase PostgREST operation failed. '
          'operation=$operation, table=$tableName, '
          'code=${exception.code}, message=${exception.message}, '
          'details=${exception.details}, hint=${exception.hint}.',
      error: exception,
      stackTrace: stackTrace,
    );
  }

  /// Logs an error raised by a Supabase Auth operation.
  void logAuthError({
    required String operation,
    required AuthException exception,
    required StackTrace stackTrace,
  }) {
    _log(
      message:
          'Supabase Auth operation failed. '
          'operation=$operation, statusCode=${exception.statusCode}, '
          'code=${exception.code}, message=${exception.message}.',
      error: exception,
      stackTrace: stackTrace,
    );
  }

  /// Logs an unexpected error raised around a Supabase operation.
  void logUnexpectedError({
    required String operation,
    required Object error,
    required StackTrace stackTrace,
    String? resource,
  }) {
    final resourceDescription = resource == null ? '' : ', resource=$resource';
    _log(
      message:
          'Unexpected Supabase error. '
          'operation=$operation$resourceDescription.',
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Logs a safe data parsing failure without retaining the payload.
  void logParsingError({
    required String operation,
    required String resource,
    required ParsingFailure failure,
    required StackTrace stackTrace,
  }) {
    _log(
      message:
          'Supabase parsing failed. '
          'operation=$operation, resource=$resource, '
          'field=${failure.field}, reason=${failure.reason.name}, '
          'expectedType=${failure.expectedType}, '
          'actualType=${failure.actualType ?? 'null'}.',
      error: failure,
      stackTrace: stackTrace,
    );
  }

  void _log({
    required String message,
    required Object error,
    required StackTrace stackTrace,
  }) {
    developer.log(
      message,
      name: 'supabase',
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
