import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:router_core/router_core.dart';

import '../../../domain/entities/evento.dart';
import '../../../domain/entities/reserva.dart';
import '../../../domain/entities/ticket.dart';
import '../../../domain/enums/reserva_estado.dart';
import '../../notifiers/mis_reservas/states/mis_reservas_error_state.dart';
import '../../notifiers/mis_reservas/states/mis_reservas_loaded_state.dart';
import '../../notifiers/mis_reservas/states/mis_reservas_loading_state.dart';
import '../../notifiers/reservas/confirmar_compra_state.dart';
import '../../notifiers/reservas/states/confirmar_compra_error_state.dart';
import '../../notifiers/reservas/states/confirmar_compra_loading_state.dart';
import '../../notifiers/reservas/states/confirmar_compra_success_state.dart';
import '../../providers/reservas_providers.dart';

class MisReservasPage extends ConsumerWidget {
  const MisReservasPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<ConfirmarCompraState>(confirmarCompraNotifierProvider, (previous, next) {
      if (next is ConfirmarCompraSuccessState) {
        ref.read(misReservasNotifierProvider.notifier).loadMisReservas();
      }
    });

    final misReservasState = ref.watch(misReservasNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mis reservas')),
      body: _buildBody(context, misReservasState),
    );
  }

  Widget _buildBody(BuildContext context, Object misReservasState) {
    if (misReservasState is MisReservasLoadingState) {
      return const Center(child: AppLoader());
    }

    if (misReservasState is MisReservasErrorState) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: AppBanner(
            message: misReservasState.failure.message,
            variant: AppBannerVariant.error,
          ),
        ),
      );
    }

    if (misReservasState is MisReservasLoadedState) {
      if (misReservasState.reservas.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: AppEmptyState(
              title: 'Aún no tienes reservas',
              description: 'Explora los eventos disponibles y reserva tu cupo.',
              icon: Icons.confirmation_number_outlined,
              actionLabel: 'Ver eventos',
              onAction: () => context.pop(),
            ),
          ),
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: misReservasState.reservas.length,
        separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (context, index) {
          final reserva = misReservasState.reservas[index];
          return _ReservaCard(
            reserva: reserva,
            evento: misReservasState.eventosPorId[reserva.eventoId],
            ticket: misReservasState.ticketsPorReservaId[reserva.id],
          );
        },
      );
    }

    return const SizedBox.shrink();
  }
}

class _ReservaCard extends ConsumerWidget {
  const _ReservaCard({required this.reserva, required this.evento, required this.ticket});

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
