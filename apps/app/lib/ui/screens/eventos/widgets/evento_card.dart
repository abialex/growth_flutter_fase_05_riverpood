import 'dart:async';

import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/evento.dart';
import 'package:router_core/router_core.dart';

class EventoCard extends StatelessWidget {
  const EventoCard({
    required this.evento,
    required this.isReservado,
    super.key,
  });

  final Evento evento;
  final bool isReservado;

  String get _fechaFormatted {
    final fecha = evento.fecha;
    final day = fecha.day.toString().padLeft(2, '0');
    final month = fecha.month.toString().padLeft(2, '0');
    return '$day/$month/${fecha.year}';
  }

  String get _horaFormatted {
    return evento.hora.length >= 5 ? evento.hora.substring(0, 5) : evento.hora;
  }

  void _onTap(BuildContext context) {
    unawaited(
      context.pushNamed('evento-detalle', pathParameters: {'id': evento.id}),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => _onTap(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  evento.nombre,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              AppChip(label: evento.deporte, emphasis: AppEmphasis.outline),
            ],
          ),
          if (isReservado) ...[
            const SizedBox(height: AppSpacing.sm),
            const AppChip(label: 'Ya reservado', emphasis: AppEmphasis.solid),
          ],
          const SizedBox(height: AppSpacing.sm),
          Text('$_fechaFormatted · $_horaFormatted'),
          Text('${evento.lugar}, ${evento.ciudad}'),
          const SizedBox(height: AppSpacing.xs),
          Text('Cupos: ${evento.cuposDisponibles}/${evento.cuposTotales}'),
        ],
      ),
    );
  }
}
