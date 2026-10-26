import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growth_flutter_fase_05_riverpood/core/config/models/app_config_model.dart';

/// Provides the configuration loaded before the app starts.
final appConfigProvider = Provider<AppConfigModel>(
  (ref) => AppConfigModel.fallback,
);
