import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/evento.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/reserva.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/eventos_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/reservas_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/events_data.dart';

/// Loads events and the current user's reservation markers.
final class LoadEventsUseCase {
  /// Creates a use case with the repositories required by the flow.
  const LoadEventsUseCase({
    required EventosRepository eventosRepository,
    required ReservasRepository reservasRepository,
  }) : _eventosRepository = eventosRepository,
       _reservasRepository = reservasRepository;

  final EventosRepository _eventosRepository;
  final ReservasRepository _reservasRepository;

  /// Loads the events displayed by the events screen.
  Future<Result<EventsData, AppFailure>> call() async {
    final eventsResult = await _eventosRepository.getEventos();
    return switch (eventsResult) {
      Failure(failure: final failure) => Failure(failure),
      Success(value: final events) => _loadReservationMarkers(events),
    };
  }

  Future<Result<EventsData, AppFailure>> _loadReservationMarkers(
    List<Evento> events,
  ) async {
    final reservationsResult = await _reservasRepository.getMisReservas();
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

  Set<String> _getReservedEventIds(List<Reserva> reservations) {
    return reservations.map((reservation) => reservation.eventoId).toSet();
  }
}
