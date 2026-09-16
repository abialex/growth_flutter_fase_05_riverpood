import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/data/services/eventos_service.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/evento.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/eventos_repository.dart';

class EventosRepositoryImpl implements EventosRepository {
  EventosRepositoryImpl(this._eventosService);

  final EventosService _eventosService;

  @override
  Future<Result<List<Evento>, AppFailure>> getEventos() {
    return _eventosService.fetchEventos();
  }

  @override
  Future<Result<Evento, AppFailure>> getEventoById(String id) {
    return _eventosService.fetchEventoById(id);
  }
}
