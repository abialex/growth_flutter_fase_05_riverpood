import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:growth_flutter_fase_05_riverpood/data/repositories/reservations_repository_impl.dart';
import 'package:growth_flutter_fase_05_riverpood/data/repositories/tickets_repository_impl.dart';
import 'package:growth_flutter_fase_05_riverpood/data/services/reservations_service.dart';
import 'package:growth_flutter_fase_05_riverpood/data/services/tickets_service.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/reservations_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/tickets_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/create_reservation_use_case.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/load_my_reservations_use_case.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/my_reservations/my_reservations_notifier.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/my_reservations/my_reservations_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservations/create_reservation_notifier.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservations/create_reservation_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/core_providers.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/event_providers.dart';

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

final createReservationNotifierProvider =
    NotifierProvider<CreateReservationNotifier, CreateReservationState>(
      CreateReservationNotifier.new,
    );

final myReservationsNotifierProvider =
    NotifierProvider<MyReservationsNotifier, MyReservationsState>(
      MyReservationsNotifier.new,
    );
