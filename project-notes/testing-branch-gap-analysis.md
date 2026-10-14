# Cambios de soporte para los tests de `fase-06-test`

## Dependencias externas

- `flutter_test`: ya estaba declarado en `apps/app/pubspec.yaml`.
- `mocktail`: faltaba aunque cuatro tests lo importan. Se agregó como dependencia de desarrollo en versión `^1.0.5` y se actualizó `apps/app/pubspec.lock`.
- No se encontraron otros imports de paquetes externos sin declarar en los tests copiados.

## Ajustes de código realizados

Se trajeron de `fase-06-testing` a `fase-06-test` los siguientes ajustes de producción:

- **Creado** `apps/app/lib/domain/use_cases/use_case.dart`: define `UseCase<Params, Output>` y `NoParams` para contratos tipados y mocks.
- **Modificado** `apps/app/lib/domain/entities/event_filters.dart`: normaliza `fromDate` y añade `matches(Event)` para evaluar los filtros.
- **Modificado** `apps/app/lib/domain/use_cases/load_event_detail_use_case.dart`: implementa `UseCase<String, ...>`.
- **Modificado** `apps/app/lib/domain/use_cases/load_events_with_reservation_markers_use_case.dart`: implementa `UseCase<NoParams, ...>`.
- **Modificado** `apps/app/lib/ui/notifiers/events/events_notifier.dart`: invoca el caso de uso con `const NoParams()`.
- **Modificado** `apps/app/lib/ui/providers/event_providers.dart`: tipa esos providers con la interfaz `UseCase` para facilitar los overrides de test.
- **Modificados** `apps/app/pubspec.yaml` y `apps/app/pubspec.lock`: agregan `mocktail ^1.0.5`.
