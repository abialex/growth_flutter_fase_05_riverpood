import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservas/reservar_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservas/states/reservar_error_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservas/states/reservar_initial_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservas/states/reservar_loading_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservas/states/reservar_success_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/reservas_providers.dart';

class ReservarNotifier extends Notifier<ReservarState> {
  @override
  ReservarState build() => const ReservarInitialState();

  Future<void> reservar({
    required String eventoId,
    required int cantidadCupos,
  }) async {
    state = const ReservarLoadingState();
    final reservasRepository = ref.read(reservasRepositoryProvider);
    final result = await reservasRepository.crearReserva(
      eventoId: eventoId,
      cantidadCupos: cantidadCupos,
    );
    state = switch (result) {
      Success() => const ReservarSuccessState(),
      Failure(failure: final appFailure) => ReservarErrorState(appFailure),
    };
  }

  void reset() {
    state = const ReservarInitialState();
  }
}
