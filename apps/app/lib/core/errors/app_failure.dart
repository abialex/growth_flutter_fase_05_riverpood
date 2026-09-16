import 'package:growth_flutter_fase_05_riverpood/core/enums/app_failure_type.dart';

/// Describes an operation failure using application-owned data.
final class AppFailure {
  const AppFailure({
    required this.failureType,
    required this.message,
  });

  final AppFailureType failureType;
  final String message;
}
