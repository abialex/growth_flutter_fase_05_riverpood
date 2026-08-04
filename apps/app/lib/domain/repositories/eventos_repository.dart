import '../../core/errors/app_failure.dart';
import '../../core/result/result.dart';
import '../entities/evento.dart';

abstract class EventosRepository {
  Future<Result<List<Evento>, AppFailure>> getEventos();

  Future<Result<Evento, AppFailure>> getEventoById(String id);
}
