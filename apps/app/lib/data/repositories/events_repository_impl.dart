import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/data/services/events_service.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/event.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/events_repository.dart';

class EventsRepositoryImpl implements EventsRepository {
  EventsRepositoryImpl(this._eventsService);

  final EventsService _eventsService;

  @override
  Future<Result<List<Event>, AppFailure>> getEvents() {
    return _eventsService.fetchEvents();
  }

  @override
  Future<Result<Event, AppFailure>> getEventById(String id) {
    return _eventsService.fetchEventById(id);
  }
}
