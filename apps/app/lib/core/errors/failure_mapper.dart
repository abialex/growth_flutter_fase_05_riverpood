import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';

/// Maps transport errors to failures owned by the application.
// ignore: one_member_abstracts
abstract interface class FailureMapper {
  /// Converts an external error into an application failure.
  AppFailure map(Object error);
}
