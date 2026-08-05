import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/reservas_repository_impl.dart';
import '../../data/services/reservas_service.dart';
import '../../domain/repositories/reservas_repository.dart';
import '../notifiers/mis_reservas/mis_reservas_notifier.dart';
import '../notifiers/mis_reservas/mis_reservas_state.dart';
import '../notifiers/reservas/confirmar_compra_notifier.dart';
import '../notifiers/reservas/confirmar_compra_state.dart';
import '../notifiers/reservas/reservar_notifier.dart';
import '../notifiers/reservas/reservar_state.dart';
import 'core_providers.dart';

final reservasServiceProvider = Provider<ReservasService>(
  (ref) => ReservasService(ref.watch(supabaseClientProvider)),
);

final reservasRepositoryProvider = Provider<ReservasRepository>(
  (ref) => ReservasRepositoryImpl(ref.watch(reservasServiceProvider)),
);

final reservarNotifierProvider = NotifierProvider<ReservarNotifier, ReservarState>(
  ReservarNotifier.new,
);

final confirmarCompraNotifierProvider =
    NotifierProvider<ConfirmarCompraNotifier, ConfirmarCompraState>(
  ConfirmarCompraNotifier.new,
);

final misReservasNotifierProvider =
    NotifierProvider<MisReservasNotifier, MisReservasState>(
  MisReservasNotifier.new,
);
