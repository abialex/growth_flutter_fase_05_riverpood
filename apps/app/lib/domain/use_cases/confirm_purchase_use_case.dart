import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/ticket.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/purchase_repository.dart';

/// Confirms a reservation and creates its ticket.
final class ConfirmPurchaseUseCase {
  /// Creates a use case with the purchase repository.
  const ConfirmPurchaseUseCase({required PurchaseRepository purchaseRepository})
    : _purchaseRepository = purchaseRepository;

  final PurchaseRepository _purchaseRepository;

  /// Confirms [reservaId] and creates its ticket atomically.
  Future<Result<Ticket, AppFailure>> call(String reservaId) {
    return _purchaseRepository.confirmPurchase(reservaId);
  }
}
