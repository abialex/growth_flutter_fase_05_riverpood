import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/event.dart';

/// Defines event operations required by the domain.
abstract class EventsRepository {
  /// Gets all available events.
  Future<Result<List<Event>, AppFailure>> getEvents();

  /// Gets an event by its [id].
  Future<Result<Event, AppFailure>> getEventById(String id);
}
