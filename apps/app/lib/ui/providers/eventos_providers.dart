import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/eventos_repository_impl.dart';
import '../../data/services/eventos_service.dart';
import '../../domain/repositories/eventos_repository.dart';
import '../notifiers/evento_detalle/evento_detalle_notifier.dart';
import '../notifiers/evento_detalle/evento_detalle_state.dart';
import '../notifiers/eventos/eventos_notifier.dart';
import '../notifiers/eventos/eventos_state.dart';
import 'core_providers.dart';

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
