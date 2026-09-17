import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservations/confirm_purchase_state.dart';

class ConfirmPurchaseErrorState extends ConfirmPurchaseState {
  const ConfirmPurchaseErrorState({
    required this.reservationId,
    required this.failure,
  });

  final String reservationId;
  final AppFailure failure;
}
