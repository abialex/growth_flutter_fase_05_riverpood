import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/event.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/reservation.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/events_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/reservations_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/event_detail_data.dart';

/// Loads an event and its reservation status for the current user.
final class LoadEventDetailUseCase {
  /// Creates a use case with the repositories required by the flow.
  const LoadEventDetailUseCase({
    required EventsRepository eventsRepository,
    required ReservationsRepository reservationsRepository,
  }) : _eventsRepository = eventsRepository,
       _reservationsRepository = reservationsRepository;

  final EventsRepository _eventsRepository;
  final ReservationsRepository _reservationsRepository;

  /// Loads detail data for [eventId].
  Future<Result<EventDetailData, AppFailure>> call(String eventId) async {
    final eventResult = await _eventsRepository.getEventById(eventId);
    return switch (eventResult) {
      Failure(failure: final failure) => Failure(failure),
      Success(value: final event) => _loadReservationStatus(eventId, event),
    };
  }

  Future<Result<EventDetailData, AppFailure>> _loadReservationStatus(
    String eventId,
    Event event,
  ) async {
    final reservationsResult = await _reservationsRepository
        .getMyReservations();
    return switch (reservationsResult) {
      Failure(failure: final failure) => Failure(failure),
      Success(value: final reservations) => Success(
        EventDetailData(
          event: event,
          isReserved: _isReserved(eventId, reservations),
        ),
      ),
    };
  }

  bool _isReserved(String eventId, List<Reservation> reservations) {
    return reservations.any(
      (reservation) => reservation.eventId == eventId,
    );
  }
}
