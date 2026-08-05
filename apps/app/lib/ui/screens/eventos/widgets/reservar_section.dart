import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/entities/evento.dart';
import '../../../notifiers/reservas/states/reservar_error_state.dart';
import '../../../notifiers/reservas/states/reservar_loading_state.dart';
import '../../../notifiers/reservas/states/reservar_success_state.dart';
import '../../../providers/reservas_providers.dart';

class ReservarSection extends ConsumerWidget {
  const ReservarSection({super.key, required this.evento, required this.isReservado});

  final Evento evento;
  final bool isReservado;

  void _onReservar(WidgetRef ref) {
    ref.read(reservarNotifierProvider.notifier).reservar(
          eventoId: evento.id,
          cantidadCupos: 1,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reservarState = ref.watch(reservarNotifierProvider);
    final isLoading = reservarState is ReservarLoadingState;
    final sinCupos = evento.cuposDisponibles <= 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (reservarState is ReservarErrorState) ...[
          AppBanner(
            message: reservarState.failure.message,
            variant: AppBannerVariant.error,
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        if (reservarState is ReservarSuccessState) ...[
          const AppBanner(
            message: 'Reserva creada correctamente',
            variant: AppBannerVariant.success,
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        if (isLoading)
          const Center(child: AppLoader())
        else if (reservarState is ReservarSuccessState)
          const SizedBox.shrink()
        else if (isReservado)
          const AppBanner(
            message: 'Ya tienes una reserva para este evento.',
            variant: AppBannerVariant.info,
          )
        else
          AppButton(
            label: sinCupos ? 'Sin cupos disponibles' : 'Reservar cupo',
            onPressed: sinCupos ? null : () => _onReservar(ref),
          ),
      ],
    );
  }
}
