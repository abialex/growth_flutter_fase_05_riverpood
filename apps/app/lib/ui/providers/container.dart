import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:growth_flutter_fase_05_riverpood/core/errors/failure_mapper.dart';
import 'package:growth_flutter_fase_05_riverpood/core/supabase/supabase_failure_mapper.dart';
import 'package:growth_flutter_fase_05_riverpood/core/supabase/supabase_logger.dart';
import 'package:growth_flutter_fase_05_riverpood/core/supabase_client.dart';
import 'package:growth_flutter_fase_05_riverpood/data/repositories/auth_repository_impl.dart';
import 'package:growth_flutter_fase_05_riverpood/data/repositories/events_repository_impl.dart';
import 'package:growth_flutter_fase_05_riverpood/data/repositories/purchase_repository_impl.dart';
import 'package:growth_flutter_fase_05_riverpood/data/repositories/reservations_repository_impl.dart';
import 'package:growth_flutter_fase_05_riverpood/data/repositories/tickets_repository_impl.dart';
import 'package:growth_flutter_fase_05_riverpood/data/services/auth_service.dart';
import 'package:growth_flutter_fase_05_riverpood/data/services/events_service.dart';
import 'package:growth_flutter_fase_05_riverpood/data/services/purchase_service.dart';
import 'package:growth_flutter_fase_05_riverpood/data/services/reservations_service.dart';
import 'package:growth_flutter_fase_05_riverpood/data/services/tickets_service.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/auth_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/events_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/purchase_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/reservations_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/tickets_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/confirm_purchase_use_case.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/create_reservation_use_case.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/load_event_detail_use_case.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/load_events_use_case.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/load_my_reservations_use_case.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/login_use_case.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/logout_use_case.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/register_use_case.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/event_detail/event_detail_notifier.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/event_detail/event_detail_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/events/events_notifier.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/events/events_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/login/login_notifier.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/login/login_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/logout/logout_notifier.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/logout/logout_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/my_reservations/my_reservations_notifier.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/my_reservations/my_reservations_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/register/register_notifier.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/register/register_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservations/confirm_purchase_notifier.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservations/confirm_purchase_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservations/create_reservation_notifier.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservations/create_reservation_state.dart';
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

final eventsServiceProvider = Provider<EventsService>(
  (ref) => EventsService(
    ref.watch(supabaseClientProvider),
    ref.watch(supabaseLoggerProvider),
    ref.watch(failureMapperProvider),
  ),
);

final eventsRepositoryProvider = Provider<EventsRepository>(
  (ref) => EventsRepositoryImpl(ref.watch(eventsServiceProvider)),
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

final reservationsServiceProvider = Provider<ReservationsService>(
  (ref) => ReservationsService(
    ref.watch(supabaseClientProvider),
    ref.watch(supabaseLoggerProvider),
    ref.watch(failureMapperProvider),
  ),
);

final reservationsRepositoryProvider = Provider<ReservationsRepository>(
  (ref) => ReservationsRepositoryImpl(ref.watch(reservationsServiceProvider)),
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
    eventsRepository: ref.watch(eventsRepositoryProvider),
    reservationsRepository: ref.watch(reservationsRepositoryProvider),
  ),
);

final loadEventDetailUseCaseProvider = Provider<LoadEventDetailUseCase>(
  (ref) => LoadEventDetailUseCase(
    eventsRepository: ref.watch(eventsRepositoryProvider),
    reservationsRepository: ref.watch(reservationsRepositoryProvider),
  ),
);

final loadMyReservationsUseCaseProvider = Provider<LoadMyReservationsUseCase>(
  (ref) => LoadMyReservationsUseCase(
    reservationsRepository: ref.watch(reservationsRepositoryProvider),
    eventsRepository: ref.watch(eventsRepositoryProvider),
    ticketsRepository: ref.watch(ticketsRepositoryProvider),
  ),
);

final createReservationUseCaseProvider = Provider<CreateReservationUseCase>(
  (ref) => CreateReservationUseCase(
    reservationsRepository: ref.watch(reservationsRepositoryProvider),
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

final eventsNotifierProvider = NotifierProvider<EventsNotifier, EventsState>(
  EventsNotifier.new,
);

final eventDetailNotifierProvider =
    NotifierProvider<EventDetailNotifier, EventDetailState>(
      EventDetailNotifier.new,
    );

final createReservationNotifierProvider =
    NotifierProvider<CreateReservationNotifier, CreateReservationState>(
      CreateReservationNotifier.new,
    );

final confirmPurchaseNotifierProvider =
    NotifierProvider<ConfirmPurchaseNotifier, ConfirmPurchaseState>(
      ConfirmPurchaseNotifier.new,
    );

final myReservationsNotifierProvider =
    NotifierProvider<MyReservationsNotifier, MyReservationsState>(
      MyReservationsNotifier.new,
    );
