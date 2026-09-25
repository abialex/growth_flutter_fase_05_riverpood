import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';

import 'package:growth_flutter_fase_05_riverpood/domain/entities/reservation_with_details.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/reservation_status.dart';

class ReservationCard extends StatelessWidget {
  const ReservationCard({
    required this.reservationDetails,
    required this.purchaseErrorMessage,
    required this.onConfirmPurchase,
    required this.isLoading,
    super.key,
  });

  final ReservationWithDetails reservationDetails;
  final String? purchaseErrorMessage;
  final VoidCallback onConfirmPurchase;
  final bool isLoading;

  String _formattedDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final reservation = reservationDetails.reservation;
    final event = reservationDetails.event;
    final ticket = reservationDetails.ticket;
    final purchaseErrorMessage = this.purchaseErrorMessage;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  event.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              AppChip(
                label: reservation.statusDisplay,
                emphasis: switch (reservation.status) {
                  ReservationStatus.pending => AppEmphasis.outline,
                  ReservationStatus.confirmed => AppEmphasis.solid,
                  ReservationStatus.cancelled => AppEmphasis.light,
                },
                isDisabled: reservation.status == ReservationStatus.cancelled,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${_formattedDate(event.date)} · '
            '${event.venue}, ${event.city}',
          ),
          const SizedBox(height: AppSpacing.xs),
          Text('Cupos reservados: ${reservation.seatCount}'),
          if (purchaseErrorMessage != null) ...[
            const SizedBox(height: AppSpacing.sm),
            AppBanner(
              message: purchaseErrorMessage,
              variant: AppBannerVariant.error,
            ),
          ],
          if (ticket != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Código de ticket: ${ticket.code}',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ] else if (reservation.canConfirmPurchase) ...[
            const SizedBox(height: AppSpacing.sm),
            if (isLoading)
              const Center(child: AppLoader(message: 'Confirmando compra...'))
            else
              AppButton(
                label: 'Confirmar compra',
                onPressed: onConfirmPurchase,
              ),
          ],
        ],
      ),
    );
  }
}
