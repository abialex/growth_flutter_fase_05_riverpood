// ignore_for_file: one_member_abstracts, this is one atomic port.

import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/ticket.dart';

/// Provides atomic purchase operations for reservations and tickets.
abstract class PurchaseRepository {
  /// Confirms a reservation and creates its ticket atomically.
  Future<Result<Ticket, AppFailure>> confirmPurchase(String reservationId);
}
