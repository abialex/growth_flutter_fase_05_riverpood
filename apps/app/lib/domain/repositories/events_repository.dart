import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/event.dart';

abstract class EventsRepository {
  Future<Result<List<Event>, AppFailure>> getEvents();

  Future<Result<Event, AppFailure>> getEventById(String id);
}
