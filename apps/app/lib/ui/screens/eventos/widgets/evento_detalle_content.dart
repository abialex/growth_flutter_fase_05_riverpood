import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../../../../domain/entities/evento.dart';

class EventoDetalleContent extends StatelessWidget {
  const EventoDetalleContent({super.key, required this.evento});

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
