import 'dart:async';

import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:growth_flutter_fase_05_riverpood/ui/layout/app_layout_tokens.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/event_detail/states/event_detail_error_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/event_detail/states/event_detail_initial_state.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(createReservationNotifierProvider.notifier).reset();
      unawaited(
        ref
            .read(eventDetailNotifierProvider.notifier)
            .loadEvent(widget.eventId),
      );
    });
  }

  void _onRetryEvent() {
    unawaited(
      ref.read(eventDetailNotifierProvider.notifier).loadEvent(widget.eventId),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<CreateReservationState>(createReservationNotifierProvider, (
      previous,
      next,
    ) {
      if (next is CreateReservationSuccessState) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Reserva creada correctamente')),
          );
        }
        unawaited(
          ref
              .read(eventDetailNotifierProvider.notifier)
              .loadEvent(widget.eventId),
        );
        unawaited(ref.read(eventsNotifierProvider.notifier).loadEvents());
        ref.read(createReservationNotifierProvider.notifier).reset();
      }
    });

    final eventDetailState = ref.watch(eventDetailNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del evento')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppLayoutTokens.contentMaxWidth,
          ),
          child: SizedBox(
            width: double.infinity,
            child: _buildBody(context, eventDetailState),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, Object eventDetailState) {
    if (eventDetailState is EventDetailInitialState ||
        eventDetailState is EventDetailLoadingState) {
      return const Center(
        child: AppLoader(message: 'Cargando detalle del evento...'),
      );
    }

    if (eventDetailState is EventDetailErrorState) {
      final failure = eventDetailState.failure;
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: AppBanner(
            message: failure.message,
            variant: AppBannerVariant.error,
            actionLabel: failure.isRetryable ? 'Reintentar' : null,
            onAction: failure.isRetryable ? _onRetryEvent : null,
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
