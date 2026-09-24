import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:growth_flutter_fase_05_riverpood/data/repositories/purchase_repository_impl.dart';
import 'package:growth_flutter_fase_05_riverpood/data/services/purchase_service.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/repositories/purchase_repository.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/use_cases/confirm_purchase_use_case.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservations/confirm_purchase_notifier.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/notifiers/reservations/confirm_purchase_state.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/providers/core_providers.dart';

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

final confirmPurchaseUseCaseProvider = Provider<ConfirmPurchaseUseCase>(
  (ref) => ConfirmPurchaseUseCase(
    purchaseRepository: ref.watch(purchaseRepositoryProvider),
  ),
);

final confirmPurchaseNotifierProvider =
    NotifierProvider<ConfirmPurchaseNotifier, ConfirmPurchaseState>(
      ConfirmPurchaseNotifier.new,
    );
