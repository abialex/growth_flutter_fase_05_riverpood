import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/core/result/result.dart';
import 'package:growth_flutter_fase_05_riverpood/data/services/purchase_service.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/ticket.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/purchase_repository.dart';

/// Supabase-backed implementation of [PurchaseRepository].
final class PurchaseRepositoryImpl implements PurchaseRepository {
  /// Creates a repository backed by the purchase service.
  PurchaseRepositoryImpl(this._purchaseService);

  final PurchaseService _purchaseService;

  @override
  Future<Result<Ticket, AppFailure>> confirmPurchase(String reservationId) {
    return _purchaseService.confirmPurchase(reservationId);
  }
}
