import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/event.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/reservation.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/events_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/reservations_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/events_data.dart';

/// Loads events and the current user's reservation markers.
final class LoadEventsUseCase {
  /// Creates a use case with the repositories required by the flow.
  const LoadEventsUseCase({
    required EventsRepository eventsRepository,
    required ReservationsRepository reservationsRepository,
  }) : _eventsRepository = eventsRepository,
       _reservationsRepository = reservationsRepository;

  final EventsRepository _eventsRepository;
  final ReservationsRepository _reservationsRepository;

  /// Loads the events displayed by the events screen.
  Future<Result<EventsData, AppFailure>> call() async {
    final eventsResult = await _eventsRepository.getEvents();
    return switch (eventsResult) {
      Failure(failure: final failure) => Failure(failure),
      Success(value: final events) => _loadReservationMarkers(events),
    };
  }

  Future<Result<EventsData, AppFailure>> _loadReservationMarkers(
    List<Event> events,
  ) async {
    final reservationsResult = await _reservationsRepository
        .getMyReservations();
    return switch (reservationsResult) {
      Failure(failure: final failure) => Failure(failure),
      Success(value: final reservations) => Success(
        EventsData(
          events: events,
          reservedEventIds: _getReservedEventIds(reservations),
        ),
      ),
    };
  }

  Set<String> _getReservedEventIds(List<Reservation> reservations) {
    return reservations.map((reservation) => reservation.eventId).toSet();
  }
}
