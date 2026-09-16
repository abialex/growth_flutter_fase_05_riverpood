import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/errors/failure_mapper.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/core/supabase/supabase_crud_service.dart';
import 'package:growth_flutter_fase_05_riverpood/core/supabase/supabase_logger.dart';
import 'package:growth_flutter_fase_05_riverpood/data/models/event_model.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/evento.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventosService {
  EventosService(
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

  Future<Result<List<Evento>, AppFailure>> fetchEventos() async {
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

  Future<Result<Evento, AppFailure>> fetchEventoById(String id) async {
    final result = await _crudService.fetchById(id);
    return switch (result) {
      Success(value: final model) => Success(model.toEntity()),
      Failure(failure: final appFailure) => Failure(appFailure),
    };
  }
}
