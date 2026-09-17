import 'dart:async';

import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/logout/logout_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/logout/states/logout_error_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/logout/states/logout_loading_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/my_reservations/states/my_reservations_error_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/my_reservations/states/my_reservations_loaded_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/my_reservations/states/my_reservations_loading_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservations/confirm_purchase_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservations/states/confirm_purchase_success_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/container.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/screens/my_reservations/widgets/reservation_card.dart';
import 'package:router_core/router_core.dart';

class MyReservationsPage extends ConsumerStatefulWidget {
  const MyReservationsPage({super.key});

  @override
  ConsumerState<MyReservationsPage> createState() => _MyReservationsPageState();
}

class _MyReservationsPageState extends ConsumerState<MyReservationsPage> {
  @override
  void initState() {
    super.initState();
    unawaited(
      ref.read(myReservationsNotifierProvider.notifier).loadMyReservations(),
    );
  }

  void _onLogout() {
    unawaited(ref.read(logoutNotifierProvider.notifier).onLogout());
  }

  void _onRetryReservations() {
    unawaited(
      ref.read(myReservationsNotifierProvider.notifier).loadMyReservations(),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref
      ..listen<ConfirmPurchaseState>(confirmPurchaseNotifierProvider, (
        previous,
        next,
      ) {
        if (next is ConfirmPurchaseSuccessState) {
          unawaited(
            ref
                .read(myReservationsNotifierProvider.notifier)
                .loadMyReservations(),
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
    final myReservationsState = ref.watch(myReservationsNotifierProvider);

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
      body: _buildBody(context, myReservationsState),
    );
  }

  Widget _buildBody(BuildContext context, Object myReservationsState) {
    if (myReservationsState is MyReservationsLoadingState) {
      return const Center(
        child: AppLoader(message: 'Cargando tus reservas...'),
      );
    }

    if (myReservationsState is MyReservationsErrorState) {
      final failure = myReservationsState.failure;
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: AppBanner(
            message: failure.message,
            variant: AppBannerVariant.error,
            actionLabel: failure.isRetryable ? 'Reintentar' : null,
            onAction: failure.isRetryable ? _onRetryReservations : null,
          ),
        ),
      );
    }

    if (myReservationsState is MyReservationsLoadedState) {
      if (myReservationsState.reservations.isEmpty) {
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
        itemCount: myReservationsState.reservations.length,
        separatorBuilder: (context, index) =>
            const SizedBox(height: AppSpacing.md),
        itemBuilder: (context, index) {
          final reservation = myReservationsState.reservations[index];
          return ReservationCard(
            reservation: reservation,
            event: myReservationsState.eventsById[reservation.eventId],
            ticket: myReservationsState.ticketsByReservationId[reservation.id],
          );
        },
      );
    }

    return const SizedBox.shrink();
  }
}
