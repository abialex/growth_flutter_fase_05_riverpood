import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:growth_flutter_fase_05_riverpood/core/config/models/app_config_model.dart';

/// Loads app display settings from `assets/config/app_config.json`.
class AppConfigService {
  /// Creates a loader that uses [rootBundle] unless another [AssetBundle] is
  /// provided.
  AppConfigService({AssetBundle? assetBundle})
    : _assetBundle = assetBundle ?? rootBundle;

  static const _assetPath = 'assets/config/app_config.json';

  final AssetBundle _assetBundle;

  /// Reads the asset, decodes its JSON, and creates an [AppConfigModel].
  ///
  /// The asset is declared in `apps/app/pubspec.yaml`. During startup, provide
  /// the result through the Riverpod container:
  ///
  /// ```dart
  /// final appConfig = await AppConfigService().load();
  /// runApp(
  ///   ProviderScope(
  ///     overrides: [appConfigProvider.overrideWithValue(appConfig)],
  ///     child: const MainApp(),
  ///   ),
  /// );
  /// ```
  ///
  /// A descendant widget reads the configuration through `appConfigProvider`:
  ///
  /// ```dart
  /// final appConfig = ref.watch(appConfigProvider);
  /// Text(appConfig.events.banner.title);
  /// ```
  ///
  /// Throws [FormatException] if the asset root is not a JSON object. Invalid
  /// or missing fields are reported by the configuration model's parser.
  Future<AppConfigModel> load() async {
    final source = await _assetBundle.loadString(_assetPath);
    final decoded = jsonDecode(source);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException(
        'The app configuration must be a JSON object.',
      );
    }
    return AppConfigModel.fromJson(decoded);
  }
}
