import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:router_core/router_core.dart';

import '../../../domain/entities/evento.dart';
import '../../notifiers/eventos/states/eventos_error_state.dart';
import '../../notifiers/eventos/states/eventos_loaded_state.dart';
import '../../notifiers/eventos/states/eventos_loading_state.dart';
import '../../providers/eventos_providers.dart';
import 'widgets/evento_card.dart';
import 'widgets/eventos_filter_bar.dart';

class EventosPage extends ConsumerStatefulWidget {
  const EventosPage({super.key});

  @override
  ConsumerState<EventosPage> createState() => _EventosPageState();
}

class _EventosPageState extends ConsumerState<EventosPage> {
  final Set<String> _selectedDeportes = {};
  String? _selectedCiudad;
  DateTime? _selectedDesde;

  bool get _hasActiveFilters => _selectedDeportes.isNotEmpty || _selectedCiudad != null || _selectedDesde != null;

  void _onToggleDeporte(String deporte, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedDeportes.add(deporte);
      } else {
        _selectedDeportes.remove(deporte);
      }
    });
  }

  void _onChangeCiudad(String? ciudad) {
    setState(() => _selectedCiudad = ciudad);
  }

  Future<void> _onPickFecha() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDesde ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) {
      setState(() => _selectedDesde = picked);
    }
  }

  void _onClearFecha() {
    setState(() => _selectedDesde = null);
  }

  void _onClearFilters() {
    setState(() {
      _selectedDeportes.clear();
      _selectedCiudad = null;
      _selectedDesde = null;
    });
  }

  List<Evento> _applyFilters(List<Evento> eventos) {
    return eventos.where((evento) {
      if (_selectedDeportes.isNotEmpty && !_selectedDeportes.contains(evento.deporte)) {
        return false;
      }
      if (_selectedCiudad != null && evento.ciudad != _selectedCiudad) {
        return false;
      }
      final selectedDesde = _selectedDesde;
      if (selectedDesde != null && evento.fecha.isBefore(selectedDesde)) {
        return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final eventosState = ref.watch(eventosNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Eventos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.confirmation_number_outlined),
            tooltip: 'Mis reservas',
            onPressed: () => context.pushNamed('mis-reservas'),
          ),
        ],
      ),
      body: _buildBody(context, eventosState),
    );
  }

  Widget _buildBody(BuildContext context, Object eventosState) {
    if (eventosState is EventosLoadingState) {
      return const Center(child: AppLoader());
    }

    if (eventosState is EventosErrorState) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: AppBanner(message: eventosState.failure.message, variant: AppBannerVariant.error),
        ),
      );
    }

    if (eventosState is EventosLoadedState) {
      if (eventosState.eventos.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: AppEmptyState(
              title: 'No hay eventos disponibles',
              description: 'Todavía no hay eventos publicados. Vuelve pronto.',
              icon: Icons.event_busy_outlined,
            ),
          ),
        );
      }

      final deportesDisponibles = eventosState.eventos.map((evento) => evento.deporte).toSet().toList()..sort();
      final ciudadesDisponibles = eventosState.eventos.map((evento) => evento.ciudad).toSet().toList()..sort();
      final eventosFiltrados = _applyFilters(eventosState.eventos);

      return Column(
        children: [
          EventosFilterBar(
            deportesDisponibles: deportesDisponibles,
            ciudadesDisponibles: ciudadesDisponibles,
            selectedDeportes: _selectedDeportes,
            selectedCiudad: _selectedCiudad,
            selectedDesde: _selectedDesde,
            hasActiveFilters: _hasActiveFilters,
            onToggleDeporte: _onToggleDeporte,
            onChangeCiudad: _onChangeCiudad,
            onPickFecha: _onPickFecha,
            onClearFecha: _onClearFecha,
            onClearFilters: _onClearFilters,
          ),
          Expanded(
            child: eventosFiltrados.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: AppEmptyState(
                        title: 'No hay eventos que coincidan con los filtros',
                        description: 'Prueba ajustando o limpiando los filtros.',
                        icon: Icons.filter_alt_off_outlined,
                        actionLabel: 'Limpiar filtros',
                        onAction: _onClearFilters,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    itemCount: eventosFiltrados.length,
                    separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, index) => EventoCard(
                      evento: eventosFiltrados[index],
                      isReservado: eventosState.eventosReservadosIds.contains(eventosFiltrados[index].id),
                    ),
                  ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}
