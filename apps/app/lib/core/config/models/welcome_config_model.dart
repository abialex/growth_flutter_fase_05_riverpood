import 'package:growth_flutter_fase_05_riverpood/core/parsing/json_parsing.dart';

/// Text configuration for the access screen.
class WelcomeConfigModel {
  /// Creates access screen text configuration.
  const WelcomeConfigModel({required this.title});

  /// Converts decoded JSON into access screen text configuration.
  factory WelcomeConfigModel.fromJson(Map<String, dynamic> json) {
    return WelcomeConfigModel(
      title: parseRequiredString(json['title'], field: 'welcome.title'),
    );
  }

  /// Access screen title.
  final String title;
}
