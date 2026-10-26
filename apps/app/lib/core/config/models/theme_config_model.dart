import 'package:flutter/material.dart';
import 'package:growth_flutter_fase_05_riverpood/core/enums/parsing_failure_reason.dart';
import 'package:growth_flutter_fase_05_riverpood/core/errors/parsing_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/parsing/json_parsing.dart';

/// Color configuration for the app theme.
class ThemeConfigModel {
  /// Creates theme configuration with its Material color seed.
  const ThemeConfigModel({required this.seedColor});

  /// Converts decoded JSON into theme configuration.
  factory ThemeConfigModel.fromJson(Map<String, dynamic> json) {
    final colorHex = parseRequiredString(
      json['seedColor'],
      field: 'theme.seedColor',
    );
    if (!RegExp(r'^#[0-9A-Fa-f]{6}$').hasMatch(colorHex)) {
      throw const ParsingFailure(
        field: 'theme.seedColor',
        reason: ParsingFailureReason.invalidValue,
        expectedType: '#RRGGBB color string',
      );
    }

    final colorValue = int.tryParse(colorHex.substring(1), radix: 16);
    if (colorValue == null) {
      throw const ParsingFailure(
        field: 'theme.seedColor',
        reason: ParsingFailureReason.invalidValue,
        expectedType: '#RRGGBB color string',
      );
    }

    return ThemeConfigModel(seedColor: Color(0xFF000000 | colorValue));
  }

  /// Seed used to generate light and dark [ColorScheme] palettes.
  final Color seedColor;

  /// Default indigo seed used when rendering without loaded configuration.
  static const fallback = ThemeConfigModel(seedColor: Color(0xFF3D5AFE));
}
