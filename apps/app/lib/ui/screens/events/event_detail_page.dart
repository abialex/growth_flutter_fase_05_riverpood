import 'dart:async';

import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/event_detail/states/event_detail_error_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/event_detail/states/event_detail_loaded_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/event_detail/states/event_detail_loading_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservations/create_reservation_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservations/states/create_reservation_success_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/container.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/screens/events/widgets/event_detail_content.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/screens/events/widgets/reservation_section.dart';

class EventDetailPage extends ConsumerStatefulWidget {
  const EventDetailPage({required this.eventId, super.key});

  final String eventId;

  @override
  ConsumerState<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends ConsumerState<EventDetailPage> {
  @override
  void initState() {
    super.initState();
    unawaited(
      ref.read(eventDetailNotifierProvider.notifier).loadEvent(widget.eventId),
    );
    ref.read(createReservationNotifierProvider.notifier).reset();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<CreateReservationState>(createReservationNotifierProvider, (
      previous,
      next,
    ) {
      if (next is CreateReservationSuccessState) {
        unawaited(
          ref
              .read(eventDetailNotifierProvider.notifier)
              .loadEvent(widget.eventId),
        );
        unawaited(ref.read(eventsNotifierProvider.notifier).loadEvents());
      }
    });

    final eventDetailState = ref.watch(eventDetailNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del evento')),
      body: _buildBody(context, eventDetailState),
    );
  }

  Widget _buildBody(BuildContext context, Object eventDetailState) {
    if (eventDetailState is EventDetailLoadingState) {
      return const Center(child: AppLoader());
    }

    if (eventDetailState is EventDetailErrorState) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: AppBanner(
            message: eventDetailState.failure.message,
            variant: AppBannerVariant.error,
          ),
        ),
      );
    }

    if (eventDetailState is EventDetailLoadedState) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            EventDetailContent(event: eventDetailState.event),
            const SizedBox(height: AppSpacing.lg),
            ReservationSection(
              event: eventDetailState.event,
              isReserved: eventDetailState.isReserved,
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
