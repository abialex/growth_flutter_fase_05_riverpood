import 'package:app_ui_kit/app_ui_kit.dart';
import 'package:flutter/material.dart';

/// Connects an app UI kit field to Flutter form validation.
class AppValidatedField extends StatelessWidget {
  /// Creates a validated text or password field.
  const AppValidatedField({
    required this.controller,
    required this.label,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.enabled = true,
    super.key,
  });

  /// Controls the field value.
  final TextEditingController controller;

  /// Label displayed by the design-system field.
  final String label;

  /// Validates the current field value.
  final FormFieldValidator<String>? validator;

  /// Keyboard type used by regular text fields.
  final TextInputType? keyboardType;

  /// Whether the field should render as a password field.
  final bool obscureText;

  /// Whether the field accepts input.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: controller.text,
      validator: validator,
      enabled: enabled,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (field) {
        final errorText = field.errorText;
        if (obscureText) {
          return AppPasswordField(
            controller: controller,
            label: label,
            errorText: errorText,
            enabled: enabled,
            onChanged: (value) => field.didChange(value),
          );
        }

        return AppTextField(
          controller: controller,
          label: label,
          errorText: errorText,
          enabled: enabled,
          keyboardType: keyboardType,
          onChanged: (value) => field.didChange(value),
        );
      },
    );
  }
}
