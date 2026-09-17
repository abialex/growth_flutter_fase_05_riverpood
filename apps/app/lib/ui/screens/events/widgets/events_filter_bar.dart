import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/screens/events/event_filters.dart';

class EventsFilterBar extends StatefulWidget {
  const EventsFilterBar({
    required this.availableSports,
    required this.availableCities,
    required this.filters,
    required this.onToggleSport,
    required this.onChangeCity,
    required this.onPickDate,
    required this.onClearDate,
    required this.onClearFilters,
    super.key,
  });

  final List<String> availableSports;
  final List<String> availableCities;
  final EventFilters filters;
  final void Function(String sport, {required bool isSelected}) onToggleSport;
  final ValueChanged<String?> onChangeCity;
  final VoidCallback onPickDate;
  final VoidCallback onClearDate;
  final VoidCallback onClearFilters;

  @override
  State<EventsFilterBar> createState() => _EventsFilterBarState();
}

class _EventsFilterBarState extends State<EventsFilterBar> {
  final _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dateController.text = _formatDate(widget.filters.fromDate);
  }

  @override
  void didUpdateWidget(covariant EventsFilterBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filters.fromDate != widget.filters.fromDate) {
      _dateController.text = _formatDate(widget.filters.fromDate);
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.md,
        top: AppSpacing.md,
        right: AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: AppSpacing.xxl,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: widget.availableSports.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(width: AppSpacing.sm),
              itemBuilder: (context, index) {
                final sport = widget.availableSports[index];
                return AppChip(
                  label: sport,
                  type: AppChipType.filter,
                  isSelected: widget.filters.selectedSports.contains(sport),
                  onSelected: (isSelected) =>
                      widget.onToggleSport(sport, isSelected: isSelected),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppDropdownField<String>(
                  key: ValueKey(widget.filters.selectedCity),
                  label: 'Ciudad',
                  hint: 'Todas',
                  initialValue: widget.filters.selectedCity,
                  items: widget.availableCities
                      .map(
                        (city) => AppDropdownItem(value: city, label: city),
                      )
                      .toList(),
                  onChanged: widget.onChangeCity,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppTextField(
                  label: 'Desde',
                  readOnly: true,
                  hint: 'Cualquiera',
                  controller: _dateController,
                  onTap: widget.onPickDate,
                  suffixIcon: widget.filters.fromDate == null
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: widget.onClearDate,
                        ),
                ),
              ),
            ],
          ),
          if (widget.filters.hasActiveFilters) ...[
            const SizedBox(height: AppSpacing.xs),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: widget.onClearFilters,
                child: const Text('Limpiar filtros'),
              ),
            ),
          ] else
            const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }
}
