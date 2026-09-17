import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';

class EventsFilterBar extends StatelessWidget {
  const EventsFilterBar({
    required this.availableSports,
    required this.availableCities,
    required this.selectedSports,
    required this.selectedCity,
    required this.selectedFrom,
    required this.hasActiveFilters,
    required this.onToggleSport,
    required this.onChangeCity,
    required this.onPickDate,
    required this.onClearDate,
    required this.onClearFilters,
    super.key,
  });

  final List<String> availableSports;
  final List<String> availableCities;
  final Set<String> selectedSports;
  final String? selectedCity;
  final DateTime? selectedFrom;
  final bool hasActiveFilters;
  final void Function(String sport, {required bool isSelected}) onToggleSport;
  final ValueChanged<String?> onChangeCity;
  final VoidCallback onPickDate;
  final VoidCallback onClearDate;
  final VoidCallback onClearFilters;

  String get _dateLabel {
    final date = selectedFrom;
    if (date == null) return '';
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: availableSports.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(width: AppSpacing.sm),
              itemBuilder: (context, index) {
                final sport = availableSports[index];
                return AppChip(
                  label: sport,
                  type: AppChipType.filter,
                  isSelected: selectedSports.contains(sport),
                  onSelected: (isSelected) =>
                      onToggleSport(sport, isSelected: isSelected),
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
                  key: ValueKey(selectedCity),
                  label: 'Ciudad',
                  hint: 'Todas',
                  initialValue: selectedCity,
                  items: availableCities
                      .map(
                        (city) => AppDropdownItem(value: city, label: city),
                      )
                      .toList(),
                  onChanged: onChangeCity,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppTextField(
                  label: 'Desde',
                  readOnly: true,
                  hint: 'Cualquiera',
                  controller: TextEditingController(text: _dateLabel),
                  onTap: onPickDate,
                  suffixIcon: selectedFrom == null
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: onClearDate,
                        ),
                ),
              ),
            ],
          ),
          if (hasActiveFilters) ...[
            const SizedBox(height: AppSpacing.xs),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: onClearFilters,
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
