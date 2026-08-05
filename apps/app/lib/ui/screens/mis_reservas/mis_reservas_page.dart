import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:router_core/router_core.dart';

import '../../notifiers/mis_reservas/states/mis_reservas_error_state.dart';
import '../../notifiers/mis_reservas/states/mis_reservas_loaded_state.dart';
import '../../notifiers/mis_reservas/states/mis_reservas_loading_state.dart';
import '../../notifiers/reservas/confirmar_compra_state.dart';
import '../../notifiers/reservas/states/confirmar_compra_success_state.dart';
import '../../providers/reservas_providers.dart';
import 'widgets/reserva_card.dart';

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
          return ReservaCard(
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
