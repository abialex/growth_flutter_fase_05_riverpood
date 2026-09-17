import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/errors/failure_mapper.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/core/supabase/supabase_logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Generic CRUD wrapper around a single Supabase table.
///
/// Feature services compose this instead of talking to [SupabaseClient]
/// directly, so every table's error handling stays in one place.
class SupabaseCrudService<ModelType> {
  SupabaseCrudService({
    required SupabaseClient supabaseClient,
    required SupabaseLogger logger,
    required FailureMapper failureMapper,
    required String tableName,
    required ModelType Function(Map<String, dynamic> jsonRow) fromJson,
  }) : _supabaseClient = supabaseClient,
       _failureMapper = failureMapper,
       _logger = logger,
       _tableName = tableName,
       _fromJson = fromJson;

  final SupabaseClient _supabaseClient;
  final FailureMapper _failureMapper;
  final SupabaseLogger _logger;
  final String _tableName;
  final ModelType Function(Map<String, dynamic> jsonRow) _fromJson;

  Future<Result<List<ModelType>, AppFailure>> fetchAll({
    String orderByColumn = 'created_at',
    bool ascending = false,
    int? limitCount,
  }) {
    return _run(
      operation: 'fetchAll',
      action: () async {
        final query = _supabaseClient
            .from(_tableName)
            .select()
            .order(orderByColumn, ascending: ascending);
        final rows = limitCount == null
            ? await query
            : await query.limit(limitCount);
        return rows.map(_fromJson).toList();
      },
    );
  }

  Future<Result<ModelType, AppFailure>> fetchById(
    String recordId, {
    String idColumn = 'id',
  }) {
    return _run(
      operation: 'fetchById',
      action: () async {
        final row = await _supabaseClient
            .from(_tableName)
            .select()
            .eq(idColumn, recordId)
            .maybeSingle();
        if (row == null) {
          throw PostgrestException(
            message: 'No row found in $_tableName for $idColumn=$recordId',
            code: 'PGRST116',
          );
        }
        return _fromJson(row);
      },
    );
  }

  Future<Result<List<ModelType>, AppFailure>> fetchWhere(
    String columnName,
    Object columnValue,
  ) {
    return _run(
      operation: 'fetchWhere',
      action: () async {
        final rows = await _supabaseClient
            .from(_tableName)
            .select()
            .eq(columnName, columnValue);
        return rows.map(_fromJson).toList();
      },
    );
  }

  /// Fetches records whose [columnName] matches any of [columnValues].
  Future<Result<List<ModelType>, AppFailure>> fetchWhereIn(
    String columnName,
    List<Object> columnValues,
  ) {
    if (columnValues.isEmpty) {
      return Future.value(
        Success<List<ModelType>, AppFailure>(<ModelType>[]),
      );
    }

    return _run(
      operation: 'fetchWhereIn',
      action: () async {
        final rows = await _supabaseClient
            .from(_tableName)
            .select()
            .inFilter(columnName, columnValues);
        return rows.map(_fromJson).toList();
      },
    );
  }

  Future<Result<ModelType, AppFailure>> insertRecord(
    Map<String, dynamic> payload,
  ) {
    return _run(
      operation: 'insertRecord',
      action: () async {
        final row = await _supabaseClient
            .from(_tableName)
            .insert(payload)
            .select()
            .single();
        return _fromJson(row);
      },
    );
  }

  Future<Result<ModelType, AppFailure>> updateRecord(
    String recordId,
    Map<String, dynamic> payload, {
    String idColumn = 'id',
  }) {
    return _run(
      operation: 'updateRecord',
      action: () async {
        final row = await _supabaseClient
            .from(_tableName)
            .update(payload)
            .eq(idColumn, recordId)
            .select()
            .single();
        return _fromJson(row);
      },
    );
  }

  Future<Result<void, AppFailure>> deleteRecord(
    String recordId, {
    String idColumn = 'id',
  }) {
    return _run(
      operation: 'deleteRecord',
      action: () async {
        await _supabaseClient.from(_tableName).delete().eq(idColumn, recordId);
      },
    );
  }

  Future<Result<ResultType, AppFailure>> _run<ResultType>({
    required String operation,
    required Future<ResultType> Function() action,
  }) async {
    try {
      final value = await action();
      return Success(value);
    } on PostgrestException catch (exception, stackTrace) {
      _logger.logPostgrestError(
        operation: operation,
        tableName: _tableName,
        exception: exception,
        stackTrace: stackTrace,
      );
      return Failure(_failureMapper.map(exception));
    } on Object catch (exception, stackTrace) {
      _logger.logUnexpectedError(
        operation: operation,
        resource: _tableName,
        error: exception,
        stackTrace: stackTrace,
      );
      return Failure(_failureMapper.map(exception));
    }
  }
}
