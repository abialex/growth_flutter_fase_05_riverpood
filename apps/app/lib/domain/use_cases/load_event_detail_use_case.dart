import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/evento.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/reserva.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/eventos_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/reservas_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/event_detail_data.dart';

/// Loads an event and its reservation status for the current user.
final class LoadEventDetailUseCase {
  /// Creates a use case with the repositories required by the flow.
  const LoadEventDetailUseCase({
    required EventosRepository eventosRepository,
    required ReservasRepository reservasRepository,
  }) : _eventosRepository = eventosRepository,
       _reservasRepository = reservasRepository;

  final EventosRepository _eventosRepository;
  final ReservasRepository _reservasRepository;

  /// Loads detail data for [eventoId].
  Future<Result<EventDetailData, AppFailure>> call(String eventoId) async {
    final eventResult = await _eventosRepository.getEventoById(eventoId);
    return switch (eventResult) {
      Failure(failure: final failure) => Failure(failure),
      Success(value: final event) => _loadReservationStatus(eventoId, event),
    };
  }

  Future<Result<EventDetailData, AppFailure>> _loadReservationStatus(
    String eventoId,
    Evento event,
  ) async {
    final reservationsResult = await _reservasRepository.getMisReservas();
    return switch (reservationsResult) {
      Failure(failure: final failure) => Failure(failure),
      Success(value: final reservations) => Success(
        EventDetailData(
          event: event,
          isReserved: _isReserved(eventoId, reservations),
        ),
      ),
    };
  }

  bool _isReserved(String eventoId, List<Reserva> reservations) {
    return reservations.any(
      (reservation) => reservation.eventoId == eventoId,
    );
  }
}
