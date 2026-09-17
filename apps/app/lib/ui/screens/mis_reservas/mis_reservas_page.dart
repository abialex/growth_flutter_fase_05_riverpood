import 'dart:async';

import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/logout/logout_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/logout/states/logout_error_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/logout/states/logout_loading_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/mis_reservas/states/mis_reservas_error_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/mis_reservas/states/mis_reservas_loaded_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/mis_reservas/states/mis_reservas_loading_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservas/confirmar_compra_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservas/states/confirmar_compra_success_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/container.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/screens/mis_reservas/widgets/reserva_card.dart';
import 'package:router_core/router_core.dart';

class MisReservasPage extends ConsumerStatefulWidget {
  const MisReservasPage({super.key});

  @override
  ConsumerState<MisReservasPage> createState() => _MisReservasPageState();
}

class _MisReservasPageState extends ConsumerState<MisReservasPage> {
  @override
  void initState() {
    super.initState();
    unawaited(ref.read(misReservasNotifierProvider.notifier).loadMisReservas());
  }

  void _onLogout() {
    unawaited(ref.read(logoutNotifierProvider.notifier).logout());
  }

  @override
  Widget build(BuildContext context) {
    ref
      ..listen<ConfirmarCompraState>(confirmarCompraNotifierProvider, (
        previous,
        next,
      ) {
        if (next is ConfirmarCompraSuccessState) {
          unawaited(
            ref.read(misReservasNotifierProvider.notifier).loadMisReservas(),
          );
        }
      })
      ..listen<LogoutState>(logoutNotifierProvider, (previous, next) {
        if (next case LogoutErrorState(:final failure)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(failure.message)),
          );
        }
      });

    final isLoggingOut =
        ref.watch(logoutNotifierProvider) is LogoutLoadingState;
    final misReservasState = ref.watch(misReservasNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis reservas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: isLoggingOut ? null : _onLogout,
          ),
        ],
      ),
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
        separatorBuilder: (context, index) =>
            const SizedBox(height: AppSpacing.md),
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
