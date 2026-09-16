import 'package:growth_flutter_fase_05_riverpood/core/errors/app_failure.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservas/confirmar_compra_state.dart';

class ConfirmarCompraErrorState extends ConfirmarCompraState {
  const ConfirmarCompraErrorState({
    required this.reservaId,
    required this.failure,
  });

  final String reservaId;
  final AppFailure failure;
}
