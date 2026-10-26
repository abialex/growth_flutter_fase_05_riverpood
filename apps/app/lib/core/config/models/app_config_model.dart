import 'package:growth_flutter_fase_05_riverpood/core/config/models/events_config_model.dart';
import 'package:growth_flutter_fase_05_riverpood/core/config/models/filters_config_model.dart';
import 'package:growth_flutter_fase_05_riverpood/core/config/models/theme_config_model.dart';
import 'package:growth_flutter_fase_05_riverpood/core/config/models/welcome_config_model.dart';
import 'package:growth_flutter_fase_05_riverpood/core/parsing/json_parsing.dart';

/// Groups the values loaded from the app configuration asset.
class AppConfigModel {
  /// Creates the complete app configuration.
  const AppConfigModel({
    required this.welcome,
    required this.events,
    required this.filters,
    required this.theme,
  });

  /// Converts decoded JSON into typed configuration values.
  factory AppConfigModel.fromJson(Map<String, dynamic> json) {
    return AppConfigModel(
      welcome: WelcomeConfigModel.fromJson(
        parseRequiredMap(json['welcome'], field: 'welcome'),
      ),
      events: EventsConfigModel.fromJson(
        parseRequiredMap(json['events'], field: 'events'),
      ),
      filters: FiltersConfigModel.fromJson(
        parseRequiredMap(json['filters'], field: 'filters'),
      ),
      theme: ThemeConfigModel.fromJson(
        parseRequiredMap(json['theme'], field: 'theme'),
      ),
    );
  }

  /// Text shown on the access screen.
  final WelcomeConfigModel welcome;

  /// Text and banner values for the event screen.
  final EventsConfigModel events;

  /// Labels used by event filters.
  final FiltersConfigModel filters;

  /// Visual theme configuration.
  final ThemeConfigModel theme;

  /// Provides defaults for previews and scopes without an asset override.
  static const fallback = AppConfigModel(
    welcome: WelcomeConfigModel(title: 'Iniciar sesión'),
    events: EventsConfigModel(
      title: 'Eventos',
      loadingMessage: 'Cargando eventos...',
      emptyTitle: 'No hay eventos disponibles',
      emptyDescription: 'Todavía no hay eventos publicados. Vuelve pronto.',
      filteredEmptyTitle: 'No hay eventos que coincidan con los filtros',
      filteredEmptyDescription: 'Prueba ajustando o limpiando los filtros.',
      banner: EventsConfigModel.fallbackBanner,
    ),
    filters: FiltersConfigModel(
      cityLabel: 'Ciudad',
      allCitiesHint: 'Todas',
      dateLabel: 'Desde',
      anyDateHint: 'Cualquiera',
      clearLabel: 'Limpiar filtros',
    ),
    theme: ThemeConfigModel.fallback,
  );
}
