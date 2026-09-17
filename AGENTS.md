# AGENTS.md

Guía operativa para trabajar en `growth_flutter_fase_05_riverpood`.

## Estado del proyecto

Este repositorio es un monorepo Flutter de la fase 05. La aplicación ya no es
el contador generado por `flutter create`; su estado y sus decisiones de
arquitectura se describen en `README.md` y en los documentos locales de
`docs/`.

El monorepo contiene:

- `apps/app`: aplicación de eventos, reservas y compras con Riverpod y
  Supabase.
- `packages/router_core`: paquete reutilizable de navegación sobre `go_router`.
- `app_ui_kit`: dependencia Git fijada al tag `v0.7.0` de la fase 04.
- `supabase/scripts`: scripts SQL numerados y ordenados para el backend.

Las restricciones principales son Dart 3.9.2 o superior y Flutter 3.35.0 o
superior.

## Arquitectura

La aplicación usa las siguientes capas:

~~~text
ui → domain/use_cases → domain/repositories → data/repositories
   → data/services → core/supabase → Supabase
~~~

- `core/` contiene utilidades transversales, `Result`, errores propios,
  parsing seguro, logging y la inicialización del cliente.
- `data/models/` representa el formato de persistencia y usa el sufijo `Model`.
  Los nombres de columnas, estados y RPC en español de la base de datos se
  mantienen únicamente en esta frontera.
- `domain/` contiene entidades, enums, contratos y casos de uso. No debe
  importar Supabase ni widgets de Flutter.
- `ui/providers/container.dart` es el composition root de Riverpod: allí se
  conectan servicios, repositorios, casos de uso y notifiers.
- `ui/layout/` contiene los tokens de layout compartidos para breakpoints y
  anchos máximos.
- `ui/` contiene navegación, pantallas, widgets, estados y notifiers. La UI
  depende de contratos y casos de uso, no de implementaciones de datos.

Las operaciones sensibles de reservas y compras se ejecutan mediante las RPC
`crear_reserva` y `confirmar_compra`. Los servicios traducen los errores de
Supabase mediante `FailureMapper`, los registran sin credenciales ni payloads
privados y entregan fallos propios al dominio.

`router_core` debe consumirse mediante `package:router_core/router_core.dart`.
Su API pública está en `lib/router_core.dart`; los detalles internos viven en
`lib/src/`. La autenticación y el guard de rutas son responsabilidad de la
aplicación consumidora.

## Configuración local

1. Ejecutar `dart pub get` y `dart run melos bootstrap` desde la raíz.
2. Copiar `apps/app/.env.example` a `apps/app/.env`.
3. Completar `SUPABASE_URL` y `SUPABASE_ANON_KEY` con la URL y la
   publishable/anon key del proyecto.
4. Nunca usar ni copiar una `service_role` key al cliente Flutter.
5. No leer, imprimir ni incluir los valores reales de `.env` en comentarios,
   logs, commits o respuestas.

El orden de los scripts de Supabase está documentado en la sección
“Configuración de Supabase” de `README.md`.

## Comandos

Desde la raíz del monorepo:

~~~powershell
dart pub get
dart run melos bootstrap
dart run melos run analyze
dart format --set-exit-if-changed .
git diff --check
~~~

Para ejecutar la app:

~~~powershell
Set-Location apps/app
flutter run
~~~

En esta fase no se agregan cambios de tests porque no forman parte del alcance
actual. No se requiere `build_runner`: el proyecto no conserva generación de
modelos.

## Convenciones de implementación

- Mantener identificadores y comentarios de código en inglés.
- Usar nombres descriptivos y el prefijo `on` para callbacks y acciones de UI.
- Evitar `!`, casts JSON inseguros y `DateTime.parse` sin fallback.
- Preferir componentes y tokens de `app_ui_kit` frente a estilos visuales
  hardcodeados.
- Mantener una clase pública principal por archivo y documentación breve para
  APIs públicas.
- Usar `apply_patch` para editar archivos manualmente.
- Preservar cambios previos del usuario y no modificar `.env`.
