import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:growth_flutter_fase_05_riverpood/core/errors/failure_mapper.dart';
import 'package:growth_flutter_fase_05_riverpood/core/supabase/supabase_failure_mapper.dart';
import 'package:growth_flutter_fase_05_riverpood/core/supabase/supabase_logger.dart';
import 'package:growth_flutter_fase_05_riverpood/core/supabase_client.dart';
import 'package:growth_flutter_fase_05_riverpood/data/repositories/auth_repository_impl.dart';
import 'package:growth_flutter_fase_05_riverpood/data/repositories/eventos_repository_impl.dart';
import 'package:growth_flutter_fase_05_riverpood/data/repositories/purchase_repository_impl.dart';
import 'package:growth_flutter_fase_05_riverpood/data/repositories/reservas_repository_impl.dart';
import 'package:growth_flutter_fase_05_riverpood/data/repositories/tickets_repository_impl.dart';
import 'package:growth_flutter_fase_05_riverpood/data/services/auth_service.dart';
import 'package:growth_flutter_fase_05_riverpood/data/services/eventos_service.dart';
import 'package:growth_flutter_fase_05_riverpood/data/services/purchase_service.dart';
import 'package:growth_flutter_fase_05_riverpood/data/services/reservas_service.dart';
import 'package:growth_flutter_fase_05_riverpood/data/services/tickets_service.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/auth_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/eventos_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/purchase_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/reservas_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/tickets_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/confirm_purchase_use_case.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/create_reservation_use_case.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/load_event_detail_use_case.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/load_events_use_case.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/load_my_reservations_use_case.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/login_use_case.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/logout_use_case.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/register_use_case.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/evento_detalle/evento_detalle_notifier.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/evento_detalle/evento_detalle_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/eventos/eventos_notifier.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/eventos/eventos_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/login/login_notifier.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/login/login_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/logout/logout_notifier.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/logout/logout_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/mis_reservas/mis_reservas_notifier.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/mis_reservas/mis_reservas_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/register/register_notifier.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/register/register_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservas/confirmar_compra_notifier.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservas/confirmar_compra_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservas/reservar_notifier.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservas/reservar_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Core dependencies.
final supabaseClientProvider = Provider<SupabaseClient>((ref) => supabase);

final supabaseLoggerProvider = Provider<SupabaseLogger>(
  (_) => const SupabaseLogger(),
);

final failureMapperProvider = Provider<FailureMapper>(
  (_) => const SupabaseFailureMapper(),
);

// Data services and repositories.
final authServiceProvider = Provider<AuthService>(
  (ref) => AuthService(
    ref.watch(supabaseClientProvider),
    ref.watch(supabaseLoggerProvider),
    ref.watch(failureMapperProvider),
  ),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(ref.watch(authServiceProvider)),
);

final eventosServiceProvider = Provider<EventosService>(
  (ref) => EventosService(
    ref.watch(supabaseClientProvider),
    ref.watch(supabaseLoggerProvider),
    ref.watch(failureMapperProvider),
  ),
);

final eventosRepositoryProvider = Provider<EventosRepository>(
  (ref) => EventosRepositoryImpl(ref.watch(eventosServiceProvider)),
);

final purchaseServiceProvider = Provider<PurchaseService>(
  (ref) => PurchaseService(
    ref.watch(supabaseClientProvider),
    ref.watch(supabaseLoggerProvider),
    ref.watch(failureMapperProvider),
  ),
);

final purchaseRepositoryProvider = Provider<PurchaseRepository>(
  (ref) => PurchaseRepositoryImpl(ref.watch(purchaseServiceProvider)),
);

final reservasServiceProvider = Provider<ReservasService>(
  (ref) => ReservasService(
    ref.watch(supabaseClientProvider),
    ref.watch(supabaseLoggerProvider),
    ref.watch(failureMapperProvider),
  ),
);

final reservasRepositoryProvider = Provider<ReservasRepository>(
  (ref) => ReservasRepositoryImpl(ref.watch(reservasServiceProvider)),
);

final ticketsServiceProvider = Provider<TicketsService>(
  (ref) => TicketsService(
    ref.watch(supabaseClientProvider),
    ref.watch(supabaseLoggerProvider),
    ref.watch(failureMapperProvider),
  ),
);

final ticketsRepositoryProvider = Provider<TicketsRepository>(
  (ref) => TicketsRepositoryImpl(ref.watch(ticketsServiceProvider)),
);

// Use cases.
final loadEventsUseCaseProvider = Provider<LoadEventsUseCase>(
  (ref) => LoadEventsUseCase(
    eventosRepository: ref.watch(eventosRepositoryProvider),
    reservasRepository: ref.watch(reservasRepositoryProvider),
  ),
);

final loadEventDetailUseCaseProvider = Provider<LoadEventDetailUseCase>(
  (ref) => LoadEventDetailUseCase(
    eventosRepository: ref.watch(eventosRepositoryProvider),
    reservasRepository: ref.watch(reservasRepositoryProvider),
  ),
);

final loadMyReservationsUseCaseProvider = Provider<LoadMyReservationsUseCase>(
  (ref) => LoadMyReservationsUseCase(
    reservasRepository: ref.watch(reservasRepositoryProvider),
    eventosRepository: ref.watch(eventosRepositoryProvider),
    ticketsRepository: ref.watch(ticketsRepositoryProvider),
  ),
);

final createReservationUseCaseProvider = Provider<CreateReservationUseCase>(
  (ref) => CreateReservationUseCase(
    reservasRepository: ref.watch(reservasRepositoryProvider),
  ),
);

final confirmPurchaseUseCaseProvider = Provider<ConfirmPurchaseUseCase>(
  (ref) => ConfirmPurchaseUseCase(
    purchaseRepository: ref.watch(purchaseRepositoryProvider),
  ),
);

final loginUseCaseProvider = Provider<LoginUseCase>(
  (ref) => LoginUseCase(
    authRepository: ref.watch(authRepositoryProvider),
  ),
);

final registerUseCaseProvider = Provider<RegisterUseCase>(
  (ref) => RegisterUseCase(
    authRepository: ref.watch(authRepositoryProvider),
  ),
);

final logoutUseCaseProvider = Provider<LogoutUseCase>(
  (ref) => LogoutUseCase(
    authRepository: ref.watch(authRepositoryProvider),
  ),
);

// Presentation notifiers.
final loginNotifierProvider = NotifierProvider<LoginNotifier, LoginState>(
  LoginNotifier.new,
);

final registerNotifierProvider =
    NotifierProvider<RegisterNotifier, RegisterState>(RegisterNotifier.new);

final logoutNotifierProvider = NotifierProvider<LogoutNotifier, LogoutState>(
  LogoutNotifier.new,
);

final eventosNotifierProvider = NotifierProvider<EventosNotifier, EventosState>(
  EventosNotifier.new,
);

final eventoDetalleNotifierProvider =
    NotifierProvider<EventoDetalleNotifier, EventoDetalleState>(
      EventoDetalleNotifier.new,
    );

final reservarNotifierProvider =
    NotifierProvider<ReservarNotifier, ReservarState>(ReservarNotifier.new);

final confirmarCompraNotifierProvider =
    NotifierProvider<ConfirmarCompraNotifier, ConfirmarCompraState>(
      ConfirmarCompraNotifier.new,
    );

final misReservasNotifierProvider =
    NotifierProvider<MisReservasNotifier, MisReservasState>(
      MisReservasNotifier.new,
    );
