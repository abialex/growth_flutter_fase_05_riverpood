import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../notifiers/evento_detalle/states/evento_detalle_error_state.dart';
import '../../notifiers/evento_detalle/states/evento_detalle_loaded_state.dart';
import '../../notifiers/evento_detalle/states/evento_detalle_loading_state.dart';
import '../../notifiers/reservas/reservar_state.dart';
import '../../notifiers/reservas/states/reservar_success_state.dart';
import '../../providers/eventos_providers.dart';
import '../../providers/reservas_providers.dart';
import 'widgets/evento_detalle_content.dart';
import 'widgets/reservar_section.dart';

class EventoDetallePage extends ConsumerStatefulWidget {
  const EventoDetallePage({super.key, required this.eventoId});

  final String eventoId;

  @override
  ConsumerState<EventoDetallePage> createState() => _EventoDetallePageState();
}

class _EventoDetallePageState extends ConsumerState<EventoDetallePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(eventoDetalleNotifierProvider.notifier).loadEvento(widget.eventoId);
      ref.read(reservarNotifierProvider.notifier).reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ReservarState>(reservarNotifierProvider, (previous, next) {
      if (next is ReservarSuccessState) {
        ref.read(eventoDetalleNotifierProvider.notifier).loadEvento(widget.eventoId);
        ref.read(eventosNotifierProvider.notifier).loadEventos();
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
