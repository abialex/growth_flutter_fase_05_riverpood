import 'dart:async';

import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/event.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/events/states/events_error_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/events/states/events_loaded_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/events/states/events_loading_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/logout/logout_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/logout/states/logout_error_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/logout/states/logout_loading_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/container.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/screens/events/widgets/event_card.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/screens/events/widgets/events_filter_bar.dart';
import 'package:router_core/router_core.dart';

class EventsPage extends ConsumerStatefulWidget {
  const EventsPage({super.key});

  @override
  ConsumerState<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends ConsumerState<EventsPage> {
  final Set<String> _selectedSports = {};
  String? _selectedCity;
  DateTime? _selectedFrom;

  @override
  void initState() {
    super.initState();
    unawaited(ref.read(eventsNotifierProvider.notifier).loadEvents());
  }

  void _onLogout() {
    unawaited(ref.read(logoutNotifierProvider.notifier).onLogout());
  }

  bool get _hasActiveFilters =>
      _selectedSports.isNotEmpty ||
      _selectedCity != null ||
      _selectedFrom != null;

  void _onToggleSport(String sport, {required bool isSelected}) {
    setState(() {
      if (isSelected) {
        _selectedSports.add(sport);
      } else {
        _selectedSports.remove(sport);
      }
    });
  }

  void _onChangeCity(String? city) {
    setState(() => _selectedCity = city);
  }

  Future<void> _onPickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedFrom ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) {
      setState(() => _selectedFrom = picked);
    }
  }

  void _onClearDate() {
    setState(() => _selectedFrom = null);
  }

  void _onClearFilters() {
    setState(() {
      _selectedSports.clear();
      _selectedCity = null;
      _selectedFrom = null;
    });
  }

  List<Event> _applyFilters(List<Event> events) {
    return events.where((event) {
      if (_selectedSports.isNotEmpty &&
          !_selectedSports.contains(event.sport)) {
        return false;
      }
      if (_selectedCity != null && event.city != _selectedCity) {
        return false;
      }
      final selectedFrom = _selectedFrom;
      if (selectedFrom != null && event.date.isBefore(selectedFrom)) {
        return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<LogoutState>(logoutNotifierProvider, (previous, next) {
      if (next case LogoutErrorState(:final failure)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.message)),
        );
      }
    });

    final isLoggingOut =
        ref.watch(logoutNotifierProvider) is LogoutLoadingState;
    final eventsState = ref.watch(eventsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Eventos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.confirmation_number_outlined),
            tooltip: 'Mis reservas',
            onPressed: () => unawaited(context.pushNamed('my-reservations')),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: isLoggingOut ? null : _onLogout,
          ),
        ],
      ),
      body: _buildBody(context, eventsState),
    );
  }

  Widget _buildBody(BuildContext context, Object eventsState) {
    if (eventsState is EventsLoadingState) {
      return const Center(child: AppLoader());
    }

    if (eventsState is EventsErrorState) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: AppBanner(
            message: eventsState.failure.message,
            variant: AppBannerVariant.error,
          ),
        ),
      );
    }

    if (eventsState is EventsLoadedState) {
      if (eventsState.events.isEmpty) {
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

      final availableSports =
          eventsState.events.map((event) => event.sport).toSet().toList()
            ..sort();
      final availableCities =
          eventsState.events.map((event) => event.city).toSet().toList()
            ..sort();
      final filteredEvents = _applyFilters(eventsState.events);

      return Column(
        children: [
          EventsFilterBar(
            availableSports: availableSports,
            availableCities: availableCities,
            selectedSports: _selectedSports,
            selectedCity: _selectedCity,
            selectedFrom: _selectedFrom,
            hasActiveFilters: _hasActiveFilters,
            onToggleSport: _onToggleSport,
            onChangeCity: _onChangeCity,
            onPickDate: _onPickDate,
            onClearDate: _onClearDate,
            onClearFilters: _onClearFilters,
          ),
          Expanded(
            child: filteredEvents.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: AppEmptyState(
                        title: 'No hay eventos que coincidan con los filtros',
                        description:
                            'Prueba ajustando o limpiando los filtros.',
                        icon: Icons.filter_alt_off_outlined,
                        actionLabel: 'Limpiar filtros',
                        onAction: _onClearFilters,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    itemCount: filteredEvents.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, index) => EventCard(
                      event: filteredEvents[index],
                      isReserved: eventsState.reservedEventIds.contains(
                        filteredEvents[index].id,
                      ),
                    ),
                  ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}
