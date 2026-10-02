import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/event.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/reservation_with_details.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/event_reservation_status.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/events_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/reservations_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/events_data.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/use_case.dart';

/// Combines events with the current user's reservation markers.
final class LoadEventsWithReservationMarkersUseCase
    implements UseCase<NoParams, Future<Result<EventsData, AppFailure>>> {
  /// Creates a use case for the events overview data.
  const LoadEventsWithReservationMarkersUseCase({
    required EventsRepository eventsRepository,
    required ReservationsRepository reservationsRepository,
  }) : _eventsRepository = eventsRepository,
       _reservationsRepository = reservationsRepository;

  final EventsRepository _eventsRepository;
  final ReservationsRepository _reservationsRepository;

  /// Loads events and marks the current user's reservation or purchase status.
  @override
  Future<Result<EventsData, AppFailure>> call(NoParams _) async {
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
        .getMyReservationsWithDetails();
    return switch (reservationsResult) {
      Failure(failure: final failure) => Failure(failure),
      Success(value: final reservations) => Success(
        EventsData(
          events: events,
          eventReservationStatuses: _getEventReservationStatuses(reservations),
        ),
      ),
    };
  }

  Map<String, EventReservationStatus> _getEventReservationStatuses(
    List<ReservationWithDetails> reservations,
  ) {
    final statuses = <String, EventReservationStatus>{};
    for (final reservationDetails in reservations) {
      final eventId = reservationDetails.reservation.eventId;
      final currentStatus = statuses[eventId];
      if (currentStatus == EventReservationStatus.purchased) continue;

      statuses[eventId] = reservationDetails.ticket == null
          ? EventReservationStatus.reserved
          : EventReservationStatus.purchased;
    }
    return statuses;
  }
}
