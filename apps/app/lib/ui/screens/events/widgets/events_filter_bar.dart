import 'dart:math' as math;

import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/layout/app_layout_tokens.dart';
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
    final labelFontSize = Theme.of(context).textTheme.labelMedium?.fontSize;
    final scaledLabelHeight = labelFontSize == null
        ? 0.0
        : MediaQuery.textScalerOf(context).scale(labelFontSize);
    final filterListHeight = math.max(
      AppSpacing.xxl,
      scaledLabelHeight + AppSpacing.md,
    );

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
            height: filterListHeight,
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
          _buildFilterFields(),
          if (widget.filters.hasActiveFilters) ...[
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerLeft,
              child: AppButton(
                label: 'Limpiar filtros',
                size: AppButtonSize.small,
                onPressed: widget.onClearFilters,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ] else
            const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }

  Widget _buildFilterFields() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cityField = _buildCityField();
        final dateField = _buildDateField();

        if (constraints.maxWidth < AppLayoutTokens.compactBreakpoint) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              cityField,
              const SizedBox(height: AppSpacing.md),
              dateField,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: cityField),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: dateField),
          ],
        );
      },
    );
  }

  Widget _buildCityField() {
    return AppDropdownField<String>(
      key: ValueKey(widget.filters.selectedCity),
      label: 'Ciudad',
      hint: 'Todas',
      initialValue: widget.filters.selectedCity,
      items: widget.availableCities
          .map((city) => AppDropdownItem(value: city, label: city))
          .toList(),
      onChanged: widget.onChangeCity,
    );
  }

  Widget _buildDateField() {
    return AppTextField(
      label: 'Desde',
      readOnly: true,
      hint: 'Cualquiera',
      controller: _dateController,
      onTap: widget.onPickDate,
      suffixIcon: widget.filters.fromDate == null
          ? null
          : IconButton(
              tooltip: 'Limpiar fecha',
              icon: const Icon(Icons.clear),
              onPressed: widget.onClearDate,
            ),
    );
  }
}
