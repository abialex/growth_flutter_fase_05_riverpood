import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/eventos/eventos_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/eventos/states/eventos_error_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/eventos/states/eventos_initial_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/eventos/states/eventos_loaded_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/eventos/states/eventos_loading_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/eventos_providers.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/reservas_providers.dart';

class EventosNotifier extends Notifier<EventosState> {
  @override
  EventosState build() {
    unawaited(Future<void>.microtask(loadEventos));
    return const EventosInitialState();
  }

  Future<void> loadEventos() async {
    state = const EventosLoadingState();
    final eventosRepository = ref.read(eventosRepositoryProvider);
    final result = await eventosRepository.getEventos();
    state = switch (result) {
      Success(value: final eventos) => EventosLoadedState(
        eventos,
        eventosReservadosIds: await _fetchEventosReservadosIds(),
      ),
      Failure(failure: final appFailure) => EventosErrorState(appFailure),
    };
  }

  Future<Set<String>> _fetchEventosReservadosIds() async {
    final reservasRepository = ref.read(reservasRepositoryProvider);
    final result = await reservasRepository.getMisReservas();
    return switch (result) {
      Success(value: final reservas) =>
        reservas.map((reserva) => reserva.eventoId).toSet(),
      Failure() => const {},
    };
  }
}
