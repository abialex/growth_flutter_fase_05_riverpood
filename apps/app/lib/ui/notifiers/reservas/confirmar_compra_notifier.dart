import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/reserva.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservas/confirmar_compra_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservas/states/confirmar_compra_error_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservas/states/confirmar_compra_initial_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservas/states/confirmar_compra_loading_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservas/states/confirmar_compra_success_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/reservas_providers.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/tickets_providers.dart';

class ConfirmarCompraNotifier extends Notifier<ConfirmarCompraState> {
  @override
  ConfirmarCompraState build() => const ConfirmarCompraInitialState();

  Future<void> confirmarCompra(String reservaId) async {
    state = ConfirmarCompraLoadingState(reservaId);

    final reservasRepository = ref.read(reservasRepositoryProvider);
    final reservaResult = await reservasRepository.confirmarReserva(reservaId);
    if (reservaResult is Failure<Reserva, AppFailure>) {
      state = ConfirmarCompraErrorState(
        reservaId: reservaId,
        failure: reservaResult.failure,
      );
      return;
    }

    final ticketsRepository = ref.read(ticketsRepositoryProvider);
    final ticketResult = await ticketsRepository.createTicket(
      reservaId: reservaId,
      codigo: _generateTicketCode(),
    );
    state = switch (ticketResult) {
      Success() => ConfirmarCompraSuccessState(reservaId),
      Failure(failure: final appFailure) => ConfirmarCompraErrorState(
        reservaId: reservaId,
        failure: appFailure,
      ),
    };
  }

  void reset() {
    state = const ConfirmarCompraInitialState();
  }

  String _generateTicketCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    final code = List.generate(
      8,
      (_) => chars[random.nextInt(chars.length)],
    ).join();
    return 'TCK-$code';
  }
}
