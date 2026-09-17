import 'dart:async';

import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/layout/app_layout_tokens.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/events/states/events_error_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/events/states/events_loaded_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/events/states/events_loading_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/logout/logout_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/logout/states/logout_error_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/logout/states/logout_loading_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/container.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/screens/events/event_filters.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/screens/events/widgets/event_card.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/screens/events/widgets/events_filter_bar.dart';
import 'package:router_core/router_core.dart';

class EventsPage extends ConsumerStatefulWidget {
  const EventsPage({super.key});

  @override
  ConsumerState<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends ConsumerState<EventsPage> {
  EventFilters _filters = EventFilters();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(ref.read(eventsNotifierProvider.notifier).loadEvents());
    });
  }

  void _onLogout() {
    unawaited(ref.read(logoutNotifierProvider.notifier).onLogout());
  }

  void _onRetryEvents() {
    unawaited(ref.read(eventsNotifierProvider.notifier).loadEvents());
  }

  void _onToggleSport(String sport, {required bool isSelected}) {
    setState(
      () => _filters = _filters.toggleSport(
        sport,
        isSelected: isSelected,
      ),
    );
  }

  void _onChangeCity(String? city) {
    setState(() => _filters = _filters.selectCity(city));
  }

  Future<void> _onPickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _filters.fromDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) {
      setState(() => _filters = _filters.selectFromDate(picked));
    }
  }

  void _onClearDate() {
    setState(() => _filters = _filters.selectFromDate(null));
  }

  void _onClearFilters() {
    setState(() => _filters = _filters.clear());
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
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppLayoutTokens.contentMaxWidth,
          ),
          child: SizedBox(
            width: double.infinity,
            child: _buildBody(context, eventsState),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, Object eventsState) {
    if (eventsState is EventsLoadingState) {
      return const Center(child: AppLoader(message: 'Cargando eventos...'));
    }

    if (eventsState is EventsErrorState) {
      final failure = eventsState.failure;
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: AppBanner(
            message: failure.message,
            variant: AppBannerVariant.error,
            actionLabel: failure.isRetryable ? 'Reintentar' : null,
            onAction: failure.isRetryable ? _onRetryEvents : null,
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
      final filteredEvents = eventsState.events
          .where(_filters.matches)
          .toList();

      return Column(
        children: [
          EventsFilterBar(
            availableSports: availableSports,
            availableCities: availableCities,
            filters: _filters,
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
