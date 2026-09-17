# Growth Flutter — Fase 05

Aplicación Flutter para consultar eventos deportivos, reservar cupos y
confirmar compras. Esta fase toma como base la infraestructura de las fases 03
y 04, incorporando Riverpod, una separación por capas, Supabase y el sistema
visual `app_ui_kit` de la fase 04.

## Requisitos

- Flutter 3.35.0 o superior.
- Dart 3.9.2 o superior.
- Un proyecto de Supabase configurado con Auth, tablas, políticas RLS y las
  funciones RPC de `supabase/scripts/`.
- Un dispositivo, emulador o navegador compatible con Flutter.

## Estructura del monorepo

~~~text
apps/app/                 Aplicación principal de eventos y reservas.
packages/router_core/     Paquete reutilizable de navegación.
app_ui_kit (Git)          Design system consumido desde el tag v0.5.1 de fase 04.
supabase/scripts/         Scripts SQL numerados para configurar Supabase.
docs/                     Requisitos y documentos de referencia local.
~~~

La dependencia visual se mantiene fijada al tag remoto `v0.5.1` para evitar
que cambios no controlados del paquete alteren esta aplicación.

## Instalación

Desde la raíz del repositorio, en PowerShell:

~~~powershell
dart pub get
dart run melos bootstrap
Copy-Item apps/app/.env.example apps/app/.env
~~~

Completa `apps/app/.env` con los valores de tu proyecto de Supabase:

~~~dotenv
SUPABASE_URL=https://your-project-ref.supabase.co
SUPABASE_ANON_KEY=your-publishable-key
~~~

## Configuración de Supabase

En el SQL Editor de Supabase, ejecuta los scripts en este orden:

1. `supabase/scripts/001-esquema-bd.sql`: crea tablas, restricciones e índices.
2. `supabase/scripts/002-politicas-rls.sql`: activa RLS y define el acceso por usuario.
3. `supabase/scripts/003-trigger-usuarios.sql`: crea el perfil de usuario después del registro
  en Supabase Auth.
4. `supabase/scripts/004-funciones-rpc.sql`: crea `crear_reserva` y `confirmar_compra`, y
  restringe las operaciones sensibles.
5. `supabase/scripts/005-seed-eventos.sql`: carga los eventos de demostración.
6. `supabase/scripts/006-ajustar-rls-usuarios.sql`: aplica el `WITH CHECK`
   explícito para actualizar el perfil del usuario.


## Arquitectura

La aplicación mantiene una dirección de dependencias de UI hacia dominio y de
dominio hacia datos:

~~~text
Pantallas y widgets
        ↓
Notifiers y estados de Riverpod
        ↓
Casos de uso
        ↓
Contratos de repositorio del dominio
        ↓
Implementaciones de repositorio
        ↓
Servicios y transporte de Supabase
        ↓
Tablas y funciones RPC
~~~

Dentro de `apps/app/lib/`:

- `core/`: configuración, `Result`, fallos, parsing seguro, logging y acceso
  compartido a Supabase.
- `data/`: modelos de persistencia con sufijo `Model`, servicios y
  repositorios concretos. Los nombres de columnas y RPC de la base de datos se
  traducen aquí.
- `domain/`: entidades, enums, contratos de repositorio y casos de uso sin
  dependencias de Flutter ni de Supabase.
- `ui/`: composición de Riverpod, navegación, notifiers, estados, pantallas y
  widgets.

`ui/providers/container.dart` centraliza la composición de servicios,
repositorios y casos de uso. `ProviderScope` proporciona el contenedor a la
aplicación; cada provider se resuelve cuando alguna parte de la UI lo necesita.
El guard de autenticación pertenece a la app y se inyecta en `router_core`.

`packages/router_core` expone su API pública desde `lib/router_core.dart` y
mantiene la implementación interna en `lib/src/`. La app conserva la decisión
de quién puede acceder a cada ruta.

## Ejecutar la aplicación

~~~powershell
Set-Location apps/app
flutter run
~~~

La navegación privada requiere una sesión válida de Supabase. La sesión
persistida se restaura al iniciar y el router redirige a login o eventos según
el estado de autenticación.

## Validación de calidad

Desde la raíz:

~~~powershell
dart run melos run analyze
dart format --set-exit-if-changed .
git diff --check
~~~

El alcance actual prioriza análisis estático, formato, arquitectura y
seguridad del flujo. No se agrega una suite de pruebas en esta fase porque no
forma parte de los requisitos actuales.

## Referencias

- [Documentación de `router_core`](packages/router_core/README.md)
