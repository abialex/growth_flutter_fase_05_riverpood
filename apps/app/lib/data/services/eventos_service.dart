import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/core/supabase/supabase_crud_service.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/evento.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventosService {
  EventosService(SupabaseClient supabaseClient)
    : _crudService = SupabaseCrudService<Evento>(
        supabaseClient: supabaseClient,
        tableName: 'eventos',
        fromJson: Evento.fromJson,
      );

  final SupabaseCrudService<Evento> _crudService;

  Future<Result<List<Evento>, AppFailure>> fetchEventos() {
    return _crudService.fetchAll(orderByColumn: 'fecha', ascending: true);
  }

  Future<Result<Evento, AppFailure>> fetchEventoById(String id) {
    return _crudService.fetchById(id);
  }
}
