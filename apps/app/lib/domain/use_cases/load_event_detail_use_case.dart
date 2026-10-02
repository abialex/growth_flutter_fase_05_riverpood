import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/event.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/reservation_with_details.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/events_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/reservations_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/event_detail_data.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/use_case.dart';

/// Loads an event and its reservation details for the current user.
final class LoadEventDetailUseCase
    implements UseCase<String, Future<Result<EventDetailData, AppFailure>>> {
  /// Creates a use case with the repositories required by the flow.
  const LoadEventDetailUseCase({
    required EventsRepository eventsRepository,
    required ReservationsRepository reservationsRepository,
  }) : _eventsRepository = eventsRepository,
       _reservationsRepository = reservationsRepository;

  final EventsRepository _eventsRepository;
  final ReservationsRepository _reservationsRepository;

  /// Loads detail data for [eventId].
  @override
  Future<Result<EventDetailData, AppFailure>> call(String eventId) async {
    final eventResult = await _eventsRepository.getEventById(eventId);
    return switch (eventResult) {
      Failure(failure: final failure) => Failure(failure),
      Success(value: final event) => _loadReservationDetails(eventId, event),
    };
  }

  Future<Result<EventDetailData, AppFailure>> _loadReservationDetails(
    String eventId,
    Event event,
  ) async {
    final reservationsResult = await _reservationsRepository
        .getMyReservationsWithDetails();
    return switch (reservationsResult) {
      Failure(failure: final failure) => Failure(failure),
      Success(value: final reservationsWithDetails) => Success(
        EventDetailData(
          event: event,
          reservationDetails: _findReservationDetails(
            eventId,
            reservationsWithDetails,
          ),
        ),
      ),
    };
  }

  ReservationWithDetails? _findReservationDetails(
    String eventId,
    List<ReservationWithDetails> reservations,
  ) {
    for (final reservationDetails in reservations) {
      if (reservationDetails.reservation.eventId == eventId) {
        return reservationDetails;
      }
    }
    return null;
  }
}
