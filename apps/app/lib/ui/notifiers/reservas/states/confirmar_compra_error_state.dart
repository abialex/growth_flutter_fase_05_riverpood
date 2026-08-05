import '../../../../core/errors/app_failure.dart';
import '../confirmar_compra_state.dart';

class ConfirmarCompraErrorState extends ConfirmarCompraState {
  const ConfirmarCompraErrorState({required this.reservaId, required this.failure});

  final String reservaId;
  final AppFailure failure;
}
