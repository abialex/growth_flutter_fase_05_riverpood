import 'dart:async';

import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/event.dart';
import 'package:router_core/router_core.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    required this.event,
    required this.isReserved,
    super.key,
  });

  final Event event;
  final bool isReserved;

  String get _formattedDate {
    final date = event.date;
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  String get _formattedTime {
    return event.time.length >= 5 ? event.time.substring(0, 5) : event.time;
  }

  void _onTap(BuildContext context) {
    unawaited(
      context.pushNamed('event-detail', pathParameters: {'id': event.id}),
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
                  event.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              AppChip(label: event.sport, emphasis: AppEmphasis.outline),
            ],
          ),
          if (isReserved) ...[
            const SizedBox(height: AppSpacing.sm),
            const AppChip(label: 'Ya reservado', emphasis: AppEmphasis.solid),
          ],
          const SizedBox(height: AppSpacing.sm),
          Text('$_formattedDate · $_formattedTime'),
          Text('${event.venue}, ${event.city}'),
          const SizedBox(height: AppSpacing.xs),
          Text('Cupos: ${event.availableSlots}/${event.totalSlots}'),
        ],
      ),
    );
  }
}
