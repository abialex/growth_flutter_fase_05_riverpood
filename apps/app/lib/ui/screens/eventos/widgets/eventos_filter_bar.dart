import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class EventosFilterBar extends StatelessWidget {
  const EventosFilterBar({
    required this.deportesDisponibles,
    required this.ciudadesDisponibles,
    required this.selectedDeportes,
    required this.selectedCiudad,
    required this.selectedDesde,
    required this.hasActiveFilters,
    required this.onToggleDeporte,
    required this.onChangeCiudad,
    required this.onPickFecha,
    required this.onClearFecha,
    required this.onClearFilters,
    super.key,
  });

  final List<String> deportesDisponibles;
  final List<String> ciudadesDisponibles;
  final Set<String> selectedDeportes;
  final String? selectedCiudad;
  final DateTime? selectedDesde;
  final bool hasActiveFilters;
  final void Function(String deporte, {required bool isSelected})
  onToggleDeporte;
  final ValueChanged<String?> onChangeCiudad;
  final VoidCallback onPickFecha;
  final VoidCallback onClearFecha;
  final VoidCallback onClearFilters;

  String get _fechaLabel {
    final fecha = selectedDesde;
    if (fecha == null) return '';
    final day = fecha.day.toString().padLeft(2, '0');
    final month = fecha.month.toString().padLeft(2, '0');
    return '$day/$month/${fecha.year}';
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
              itemCount: deportesDisponibles.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(width: AppSpacing.sm),
              itemBuilder: (context, index) {
                final deporte = deportesDisponibles[index];
                return AppChip(
                  label: deporte,
                  type: AppChipType.filter,
                  isSelected: selectedDeportes.contains(deporte),
                  onSelected: (isSelected) =>
                      onToggleDeporte(deporte, isSelected: isSelected),
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
                  key: ValueKey(selectedCiudad),
                  label: 'Ciudad',
                  hint: 'Todas',
                  initialValue: selectedCiudad,
                  items: ciudadesDisponibles
                      .map(
                        (ciudad) =>
                            AppDropdownItem(value: ciudad, label: ciudad),
                      )
                      .toList(),
                  onChanged: onChangeCiudad,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppTextField(
                  label: 'Desde',
                  readOnly: true,
                  hint: 'Cualquiera',
                  controller: TextEditingController(text: _fechaLabel),
                  onTap: onPickFecha,
                  suffixIcon: selectedDesde == null
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: onClearFecha,
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
