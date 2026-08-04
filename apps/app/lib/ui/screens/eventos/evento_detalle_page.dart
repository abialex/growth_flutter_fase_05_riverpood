import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/evento.dart';
import '../../notifiers/evento_detalle/states/evento_detalle_error_state.dart';
import '../../notifiers/evento_detalle/states/evento_detalle_loaded_state.dart';
import '../../notifiers/evento_detalle/states/evento_detalle_loading_state.dart';
import '../../notifiers/reservas/reservar_state.dart';
import '../../notifiers/reservas/states/reservar_error_state.dart';
import '../../notifiers/reservas/states/reservar_loading_state.dart';
import '../../notifiers/reservas/states/reservar_success_state.dart';
import '../../providers/eventos_providers.dart';
import '../../providers/reservas_providers.dart';

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
            _EventoDetalleContent(evento: eventoDetalleState.evento),
            const SizedBox(height: AppSpacing.lg),
            _ReservarSection(
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

class _EventoDetalleContent extends StatelessWidget {
  const _EventoDetalleContent({required this.evento});

  final Evento evento;

  String get _fechaFormatted {
    final fecha = evento.fecha;
    final day = fecha.day.toString().padLeft(2, '0');
    final month = fecha.month.toString().padLeft(2, '0');
    return '$day/$month/${fecha.year}';
  }

  String get _horaFormatted {
    return evento.hora.length >= 5 ? evento.hora.substring(0, 5) : evento.hora;
  }

  @override
  Widget build(BuildContext context) {
    final descripcion = evento.descripcion;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  evento.nombre,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              AppChip(label: evento.deporte, emphasis: AppEmphasis.outline),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Fecha y hora', style: Theme.of(context).textTheme.labelLarge),
          Text('$_fechaFormatted · $_horaFormatted'),
          const SizedBox(height: AppSpacing.md),
          Text('Lugar', style: Theme.of(context).textTheme.labelLarge),
          Text('${evento.lugar}, ${evento.ciudad}'),
          const SizedBox(height: AppSpacing.md),
          Text('Cupos', style: Theme.of(context).textTheme.labelLarge),
          Text('${evento.cuposDisponibles} disponibles de ${evento.cuposTotales}'),
          const SizedBox(height: AppSpacing.md),
          Text('Estado', style: Theme.of(context).textTheme.labelLarge),
          Text(evento.estado.name),
          if (descripcion != null && descripcion.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Text('Descripción', style: Theme.of(context).textTheme.labelLarge),
            Text(descripcion),
          ],
        ],
      ),
    );
  }
}

class _ReservarSection extends ConsumerWidget {
  const _ReservarSection({required this.evento, required this.isReservado});

  final Evento evento;
  final bool isReservado;

  void _onReservar(WidgetRef ref) {
    ref.read(reservarNotifierProvider.notifier).reservar(
          eventoId: evento.id,
          cantidadCupos: 1,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reservarState = ref.watch(reservarNotifierProvider);
    final isLoading = reservarState is ReservarLoadingState;
    final sinCupos = evento.cuposDisponibles <= 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (reservarState is ReservarErrorState) ...[
          AppBanner(
            message: reservarState.failure.message,
            variant: AppBannerVariant.error,
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        if (reservarState is ReservarSuccessState) ...[
          const AppBanner(
            message: 'Reserva creada correctamente',
            variant: AppBannerVariant.success,
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        if (isLoading)
          const Center(child: AppLoader())
        else if (isReservado)
          const AppBanner(
            message: 'Ya tienes una reserva para este evento.',
            variant: AppBannerVariant.info,
          )
        else
          AppButton(
            label: sinCupos ? 'Sin cupos disponibles' : 'Reservar cupo',
            onPressed: sinCupos ? null : () => _onReservar(ref),
          ),
      ],
    );
  }
}
