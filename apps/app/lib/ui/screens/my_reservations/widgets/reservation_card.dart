import 'dart:async';

import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:growth_flutter_fase_05_riverpood/domain/entities/event.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/reservation.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/ticket.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/reservation_status.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservations/states/confirm_purchase_error_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservations/states/confirm_purchase_loading_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/container.dart';

class ReservationCard extends ConsumerWidget {
  const ReservationCard({
    required this.reservation,
    required this.event,
    required this.ticket,
    super.key,
  });

  final Reservation reservation;
  final Event? event;
  final Ticket? ticket;

  String _formattedDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  void _onConfirmPurchase(WidgetRef ref) {
    unawaited(
      ref
          .read(confirmPurchaseNotifierProvider.notifier)
          .onConfirmPurchase(reservation.id),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final event = this.event;
    final ticket = this.ticket;
    final confirmPurchaseState = ref.watch(confirmPurchaseNotifierProvider);

    final isConfirmingReservation =
        confirmPurchaseState is ConfirmPurchaseLoadingState &&
        confirmPurchaseState.reservationId == reservation.id;
    final reservationError =
        confirmPurchaseState is ConfirmPurchaseErrorState &&
            confirmPurchaseState.reservationId == reservation.id
        ? confirmPurchaseState
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
                  event?.name ?? 'Evento no encontrado',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              AppChip(
                label: switch (reservation.status) {
                  ReservationStatus.pending => 'pendiente',
                  ReservationStatus.confirmed => 'confirmada',
                  ReservationStatus.cancelled => 'cancelada',
                },
                emphasis: switch (reservation.status) {
                  ReservationStatus.pending => AppEmphasis.outline,
                  ReservationStatus.confirmed => AppEmphasis.solid,
                  ReservationStatus.cancelled => AppEmphasis.light,
                },
                isDisabled: reservation.status == ReservationStatus.cancelled,
              ),
            ],
          ),
          if (event != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              '${_formattedDate(event.date)} · '
              '${event.venue}, ${event.city}',
            ),
          ],
          const SizedBox(height: AppSpacing.xs),
          Text('Cupos reservados: ${reservation.seatCount}'),
          if (reservationError != null) ...[
            const SizedBox(height: AppSpacing.sm),
            AppBanner(
              message: reservationError.failure.message,
              variant: AppBannerVariant.error,
            ),
          ],
          if (ticket != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Código de ticket: ${ticket.code}',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ] else if (reservation.status != ReservationStatus.cancelled) ...[
            const SizedBox(height: AppSpacing.sm),
            AppButton(
              label: 'Confirmar compra',
              isLoading: isConfirmingReservation,
              onPressed: isConfirmingReservation
                  ? null
                  : () => _onConfirmPurchase(ref),
            ),
          ],
        ],
      ),
    );
  }
}
