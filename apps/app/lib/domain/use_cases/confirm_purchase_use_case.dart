import 'dart:math';

import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/ticket.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/reservas_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/tickets_repository.dart';

/// Confirms a reservation and creates its ticket.
final class ConfirmPurchaseUseCase {
  /// Creates a use case with the repositories required by the flow.
  const ConfirmPurchaseUseCase({
    required ReservasRepository reservasRepository,
    required TicketsRepository ticketsRepository,
  }) : _reservasRepository = reservasRepository,
       _ticketsRepository = ticketsRepository;

  final ReservasRepository _reservasRepository;
  final TicketsRepository _ticketsRepository;

  /// Confirms [reservaId] and creates the corresponding ticket.
  Future<Result<Ticket, AppFailure>> call(String reservaId) async {
    final reservationResult = await _reservasRepository.confirmarReserva(
      reservaId,
    );
    if (reservationResult case Failure(failure: final failure)) {
      return Failure(failure);
    }

    return _createTicket(reservaId);
  }

  Future<Result<Ticket, AppFailure>> _createTicket(String reservaId) {
    return _ticketsRepository.createTicket(
      reservaId: reservaId,
      codigo: _generateTicketCode(),
    );
  }

  String _generateTicketCode() {
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random.secure();
    final code = List.generate(
      8,
      (_) => characters[random.nextInt(characters.length)],
    ).join();
    return 'TCK-$code';
  }
}
