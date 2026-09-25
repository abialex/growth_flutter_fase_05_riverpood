import 'dart:async';

import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:growth_flutter_fase_05_riverpood/domain/entities/reservation_eligibility.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservations/states/create_reservation_error_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservations/states/create_reservation_loading_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/container.dart';

class ReservationSection extends ConsumerWidget {
  const ReservationSection({
    required this.eventId,
    required this.eligibility,
    super.key,
  });

  final String eventId;
  final ReservationEligibility eligibility;

  void _onCreateReservation(WidgetRef ref) {
    unawaited(
      ref
          .read(createReservationNotifierProvider.notifier)
          .onCreateReservation(
            eventId: eventId,
            seatCount: 1,
          ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createReservationState = ref.watch(createReservationNotifierProvider);
    final isLoading = createReservationState is CreateReservationLoadingState;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (createReservationState is CreateReservationErrorState) ...[
          AppBanner(
            message: createReservationState.failure.message,
            variant: AppBannerVariant.error,
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        if (isLoading)
          const Center(child: AppLoader(message: 'Procesando reserva...'))
        else if (eligibility.isAlreadyReserved)
          AppBanner(
            message: eligibility.actionLabel,
          )
        else
          AppButton(
            label: eligibility.actionLabel,
            onPressed: eligibility.canReserve
                ? () => _onCreateReservation(ref)
                : null,
          ),
      ],
    );
  }
}
