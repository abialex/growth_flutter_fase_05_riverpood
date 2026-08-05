import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/entities/evento.dart';
import '../../../../domain/entities/reserva.dart';
import '../../../../domain/entities/ticket.dart';
import '../../../../domain/enums/reserva_estado.dart';
import '../../../notifiers/reservas/states/confirmar_compra_error_state.dart';
import '../../../notifiers/reservas/states/confirmar_compra_loading_state.dart';
import '../../../providers/reservas_providers.dart';

class ReservaCard extends ConsumerWidget {
  const ReservaCard({super.key, required this.reserva, required this.evento, required this.ticket});

  final Reserva reserva;
  final Evento? evento;
  final Ticket? ticket;

  String _fechaFormatted(DateTime fecha) {
    final day = fecha.day.toString().padLeft(2, '0');
    final month = fecha.month.toString().padLeft(2, '0');
    return '$day/$month/${fecha.year}';
  }

  void _onConfirmarCompra(WidgetRef ref) {
    ref.read(confirmarCompraNotifierProvider.notifier).confirmarCompra(reserva.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final evento = this.evento;
    final ticket = this.ticket;
    final confirmarCompraState = ref.watch(confirmarCompraNotifierProvider);

    final isConfirmandoEstaReserva = confirmarCompraState is ConfirmarCompraLoadingState &&
        confirmarCompraState.reservaId == reserva.id;
    final errorEstaReserva = confirmarCompraState is ConfirmarCompraErrorState &&
            confirmarCompraState.reservaId == reserva.id
        ? confirmarCompraState
        : null;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  evento?.nombre ?? 'Evento no encontrado',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              AppChip(
                label: reserva.estado.name,
                emphasis: switch (reserva.estado) {
                  ReservaEstado.pendiente => AppEmphasis.outline,
                  ReservaEstado.confirmada => AppEmphasis.solid,
                  ReservaEstado.cancelada => AppEmphasis.light,
                },
                isDisabled: reserva.estado == ReservaEstado.cancelada,
              ),
            ],
          ),
          if (evento != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text('${_fechaFormatted(evento.fecha)} · ${evento.lugar}, ${evento.ciudad}'),
          ],
          const SizedBox(height: AppSpacing.xs),
          Text('Cupos reservados: ${reserva.cantidadCupos}'),
          if (errorEstaReserva != null) ...[
            const SizedBox(height: AppSpacing.sm),
            AppBanner(
              message: errorEstaReserva.failure.message,
              variant: AppBannerVariant.error,
            ),
          ],
          if (ticket != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Código de ticket: ${ticket.codigo}',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ] else if (reserva.estado != ReservaEstado.cancelada) ...[
            const SizedBox(height: AppSpacing.sm),
            AppButton(
              label: 'Confirmar compra',
              isLoading: isConfirmandoEstaReserva,
              onPressed: isConfirmandoEstaReserva ? null : () => _onConfirmarCompra(ref),
            ),
          ],
        ],
      ),
    );
  }
}
