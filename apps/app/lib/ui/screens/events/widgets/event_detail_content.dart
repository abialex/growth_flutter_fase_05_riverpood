import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';

import 'package:growth_flutter_fase_05_riverpood/domain/entities/event.dart';

class EventDetailContent extends StatelessWidget {
  const EventDetailContent({required this.event, super.key});

  final Event event;

  String get _formattedDate {
    final date = event.date;
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  String get _formattedTime {
    if (event.time.length < 5) {
      return event.time;
    }
    return event.time.substring(0, 5);
  }

  @override
  Widget build(BuildContext context) {
    final description = event.description;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  event.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              AppChip(label: event.sport, emphasis: AppEmphasis.outline),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Fecha y hora', style: Theme.of(context).textTheme.labelLarge),
          Text('$_formattedDate · $_formattedTime'),
          const SizedBox(height: AppSpacing.md),
          Text('Lugar', style: Theme.of(context).textTheme.labelLarge),
          Text('${event.venue}, ${event.city}'),
          const SizedBox(height: AppSpacing.md),
          Text('Cupos', style: Theme.of(context).textTheme.labelLarge),
          Text(
            '${event.availableSlots} disponibles de ${event.totalSlots}',
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Estado', style: Theme.of(context).textTheme.labelLarge),
          Text(event.statusDisplay),
          if (description != null && description.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Text('Descripción', style: Theme.of(context).textTheme.labelLarge),
            Text(description),
          ],
        ],
      ),
    );
  }
}
