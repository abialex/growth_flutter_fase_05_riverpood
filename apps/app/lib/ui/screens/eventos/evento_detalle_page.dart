import 'dart:async';

import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/evento_detalle/states/evento_detalle_error_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/evento_detalle/states/evento_detalle_loaded_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/evento_detalle/states/evento_detalle_loading_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservas/reservar_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservas/states/reservar_success_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/eventos_providers.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/reservas_providers.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/screens/eventos/widgets/evento_detalle_content.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/screens/eventos/widgets/reservar_section.dart';

class EventoDetallePage extends ConsumerStatefulWidget {
  const EventoDetallePage({required this.eventoId, super.key});

  final String eventoId;

  @override
  ConsumerState<EventoDetallePage> createState() => _EventoDetallePageState();
}

class _EventoDetallePageState extends ConsumerState<EventoDetallePage> {
  @override
  void initState() {
    super.initState();
    unawaited(
      ref
          .read(eventoDetalleNotifierProvider.notifier)
          .loadEvento(widget.eventoId),
    );
    ref.read(reservarNotifierProvider.notifier).reset();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ReservarState>(reservarNotifierProvider, (previous, next) {
      if (next is ReservarSuccessState) {
        unawaited(
          ref
              .read(eventoDetalleNotifierProvider.notifier)
              .loadEvento(widget.eventoId),
        );
        unawaited(ref.read(eventosNotifierProvider.notifier).loadEventos());
      }
    });

    final eventoDetalleState = ref.watch(eventoDetalleNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del evento')),
      body: _buildBody(context, eventoDetalleState),
    );
  }

  Widget _buildBody(BuildContext context, Object eventoDetalleState) {
    if (eventoDetalleState is EventoDetalleLoadingState) {
      return const Center(child: AppLoader());
    }

    if (eventoDetalleState is EventoDetalleErrorState) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: AppBanner(
            message: eventoDetalleState.failure.message,
            variant: AppBannerVariant.error,
          ),
        ),
      );
    }

    if (eventoDetalleState is EventoDetalleLoadedState) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            EventoDetalleContent(evento: eventoDetalleState.evento),
            const SizedBox(height: AppSpacing.lg),
            ReservarSection(
              evento: eventoDetalleState.evento,
              isReservado: eventoDetalleState.isReservado,
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
