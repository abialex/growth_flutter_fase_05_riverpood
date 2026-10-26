import 'package:growth_flutter_fase_05_riverpood/core/config/models/events_banner_config_model.dart';
import 'package:growth_flutter_fase_05_riverpood/core/parsing/json_parsing.dart';

/// Text and banner configuration for the event screen.
class EventsConfigModel {
  /// Creates event screen configuration.
  const EventsConfigModel({
    required this.title,
    required this.loadingMessage,
    required this.emptyTitle,
    required this.emptyDescription,
    required this.filteredEmptyTitle,
    required this.filteredEmptyDescription,
    required this.banner,
  });

  /// Converts decoded JSON into event screen configuration.
  factory EventsConfigModel.fromJson(Map<String, dynamic> json) {
    return EventsConfigModel(
      title: parseRequiredString(json['title'], field: 'events.title'),
      loadingMessage: parseRequiredString(
        json['loadingMessage'],
        field: 'events.loadingMessage',
      ),
      emptyTitle: parseRequiredString(
        json['emptyTitle'],
        field: 'events.emptyTitle',
      ),
      emptyDescription: parseRequiredString(
        json['emptyDescription'],
        field: 'events.emptyDescription',
      ),
      filteredEmptyTitle: parseRequiredString(
        json['filteredEmptyTitle'],
        field: 'events.filteredEmptyTitle',
      ),
      filteredEmptyDescription: parseRequiredString(
        json['filteredEmptyDescription'],
        field: 'events.filteredEmptyDescription',
      ),
      banner: EventsBannerConfigModel.fromJson(
        parseRequiredMap(json['banner'], field: 'events.banner'),
      ),
    );
  }

  /// Provides a default banner for previews and tests.
  static const fallbackBanner = EventsBannerConfigModel(
    enabled: true,
    title: 'Vive la emoción del deporte',
    message: 'Explora los próximos eventos y reserva tu lugar.',
  );

  /// Events screen title.
  final String title;

  /// Message shown while events load.
  final String loadingMessage;

  /// Title shown when there are no events.
  final String emptyTitle;

  /// Description shown when there are no events.
  final String emptyDescription;

  /// Title shown when filters produce no results.
  final String filteredEmptyTitle;

  /// Description shown when filters produce no results.
  final String filteredEmptyDescription;

  /// Informational banner shown above the event filters.
  final EventsBannerConfigModel banner;
}
