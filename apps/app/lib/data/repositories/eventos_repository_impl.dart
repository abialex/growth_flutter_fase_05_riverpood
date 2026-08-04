import '../../core/errors/app_failure.dart';
import '../../core/result/result.dart';
import '../../domain/entities/evento.dart';
import '../../domain/repositories/eventos_repository.dart';
import '../services/eventos_service.dart';

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
