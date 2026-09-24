import 'dart:async';

import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:growth_flutter_fase_05_riverpood/domain/entities/event.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/event_status.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservations/states/create_reservation_error_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservations/states/create_reservation_loading_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/container.dart';

class ReservationSection extends ConsumerWidget {
  const ReservationSection({
    required this.event,
    required this.isReserved,
    super.key,
  });

  final Event event;
  final bool isReserved;

  String get _reservationButtonLabel {
    if (event.status == EventStatus.unknown) {
      return 'Estado desconocido';
    }
    if (event.availableSlots <= 0) {
      return 'Sin cupos disponibles';
    }
    if (!event.canAcceptReservations) {
      return 'Reservas cerradas';
    }

    return 'Reservar cupo';
  }

  void _onCreateReservation(WidgetRef ref) {
    unawaited(
      ref
          .read(createReservationNotifierProvider.notifier)
          .onCreateReservation(
            eventId: event.id,
            seatCount: 1,
          ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createReservationState = ref.watch(createReservationNotifierProvider);
    final isLoading = createReservationState is CreateReservationLoadingState;
    final canReserve = event.canAcceptReservations;

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
        else if (isReserved)
          const AppBanner(
            message: 'Ya tienes una reserva para este evento.',
          )
        else
          AppButton(
            label: _reservationButtonLabel,
            onPressed: canReserve ? () => _onCreateReservation(ref) : null,
          ),
      ],
    );
  }
}
