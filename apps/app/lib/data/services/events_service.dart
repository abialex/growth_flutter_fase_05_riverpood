import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/errors/failure_mapper.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/core/supabase/supabase_crud_service.dart';
import 'package:growth_flutter_fase_05_riverpood/core/supabase/supabase_logger.dart';
import 'package:growth_flutter_fase_05_riverpood/data/models/event_model.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/event.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Loads event data from Supabase and maps it to domain entities.
class EventsService {
  /// Creates an event service with its external dependencies.
  EventsService(
    SupabaseClient supabaseClient,
    SupabaseLogger logger,
    FailureMapper failureMapper,
  ) : _crudService = SupabaseCrudService<EventModel>(
        supabaseClient: supabaseClient,
        logger: logger,
        failureMapper: failureMapper,
        tableName: 'eventos',
        fromJson: EventModel.fromJson,
      );

  final SupabaseCrudService<EventModel> _crudService;

  /// Fetches all events ordered by date.
  Future<Result<List<Event>, AppFailure>> fetchEvents() async {
    final result = await _crudService.fetchAll(
      orderByColumn: 'fecha',
      ascending: true,
    );
    return switch (result) {
      Success(value: final models) => Success(
        models.map((model) => model.toEntity()).toList(),
      ),
      Failure(failure: final appFailure) => Failure(appFailure),
    };
  }

  /// Fetches an event by its [id].
  Future<Result<Event, AppFailure>> fetchEventById(String id) async {
    final result = await _crudService.fetchById(id);
    return switch (result) {
      Success(value: final model) => Success(model.toEntity()),
      Failure(failure: final appFailure) => Failure(appFailure),
    };
  }
}
