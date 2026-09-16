import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/evento.dart';

abstract class EventosRepository {
  Future<Result<List<Evento>, AppFailure>> getEventos();

  Future<Result<Evento, AppFailure>> getEventoById(String id);
}
