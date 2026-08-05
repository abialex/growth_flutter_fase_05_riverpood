import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:router_core/router_core.dart';

import '../../../../domain/entities/evento.dart';

class EventoCard extends StatelessWidget {
  const EventoCard({super.key, required this.evento, required this.isReservado});

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
    context.pushNamed('evento-detalle', pathParameters: {'id': evento.id});
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
