import 'package:growth_flutter_fase_05_riverpood/core/parsing/json_parsing.dart';

/// Visibility and copy configuration for the events banner.
class EventsBannerConfigModel {
  /// Creates banner configuration.
  const EventsBannerConfigModel({
    required this.enabled,
    required this.title,
    required this.message,
  });

  /// Converts decoded JSON into banner configuration.
  factory EventsBannerConfigModel.fromJson(Map<String, dynamic> json) {
    return EventsBannerConfigModel(
      enabled: parseRequiredBool(
        json['enabled'],
        field: 'events.banner.enabled',
      ),
      title: parseRequiredString(
        json['title'],
        field: 'events.banner.title',
      ),
      message: parseRequiredString(
        json['message'],
        field: 'events.banner.message',
      ),
    );
  }

  /// Whether the events banner is visible.
  final bool enabled;

  /// Banner heading.
  final String title;

  /// Banner message.
  final String message;
}
