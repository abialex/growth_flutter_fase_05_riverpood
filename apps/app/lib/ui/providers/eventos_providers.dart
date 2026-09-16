import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:growth_flutter_fase_05_riverpood/data/repositories/eventos_repository_impl.dart';
import 'package:growth_flutter_fase_05_riverpood/data/services/eventos_service.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/eventos_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/evento_detalle/evento_detalle_notifier.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/evento_detalle/evento_detalle_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/eventos/eventos_notifier.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/eventos/eventos_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/core_providers.dart';

final eventosServiceProvider = Provider<EventosService>(
  (ref) => EventosService(ref.watch(supabaseClientProvider)),
);

final eventosRepositoryProvider = Provider<EventosRepository>(
  (ref) => EventosRepositoryImpl(ref.watch(eventosServiceProvider)),
);

final eventosNotifierProvider = NotifierProvider<EventosNotifier, EventosState>(
  EventosNotifier.new,
);

final eventoDetalleNotifierProvider =
    NotifierProvider<EventoDetalleNotifier, EventoDetalleState>(
      EventoDetalleNotifier.new,
    );
