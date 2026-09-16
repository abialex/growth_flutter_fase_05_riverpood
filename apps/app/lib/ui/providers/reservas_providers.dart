import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:growth_flutter_fase_05_riverpood/data/repositories/reservas_repository_impl.dart';
import 'package:growth_flutter_fase_05_riverpood/data/services/reservas_service.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/reservas_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/mis_reservas/mis_reservas_notifier.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/mis_reservas/mis_reservas_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservas/confirmar_compra_notifier.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservas/confirmar_compra_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservas/reservar_notifier.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservas/reservar_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/core_providers.dart';

final reservasServiceProvider = Provider<ReservasService>(
  (ref) => ReservasService(ref.watch(supabaseClientProvider)),
);

final reservasRepositoryProvider = Provider<ReservasRepository>(
  (ref) => ReservasRepositoryImpl(ref.watch(reservasServiceProvider)),
);

final reservarNotifierProvider =
    NotifierProvider<ReservarNotifier, ReservarState>(
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
