import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/errors/app_failure.dart';
import '../../core/result/result.dart';
import '../../core/supabase/supabase_crud_service.dart';
import '../../domain/entities/evento.dart';

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
