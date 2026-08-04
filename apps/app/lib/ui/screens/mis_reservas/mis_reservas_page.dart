import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:router_core/router_core.dart';

import '../../../domain/entities/evento.dart';
import '../../../domain/entities/reserva.dart';
import '../../../domain/enums/reserva_estado.dart';
import '../../notifiers/mis_reservas/states/mis_reservas_error_state.dart';
import '../../notifiers/mis_reservas/states/mis_reservas_loaded_state.dart';
import '../../notifiers/mis_reservas/states/mis_reservas_loading_state.dart';
import '../../providers/reservas_providers.dart';

class MisReservasPage extends ConsumerWidget {
  const MisReservasPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        itemBuilder: (context, index) => _ReservaCard(
          reserva: misReservasState.reservas[index],
          evento: misReservasState.eventosPorId[misReservasState.reservas[index].eventoId],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

class _ReservaCard extends StatelessWidget {
  const _ReservaCard({required this.reserva, required this.evento});

  final Reserva reserva;
  final Evento? evento;

  String _fechaFormatted(DateTime fecha) {
    final day = fecha.day.toString().padLeft(2, '0');
    final month = fecha.month.toString().padLeft(2, '0');
    return '$day/$month/${fecha.year}';
  }

  @override
  Widget build(BuildContext context) {
    final evento = this.evento;

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
        ],
      ),
    );
  }
}
