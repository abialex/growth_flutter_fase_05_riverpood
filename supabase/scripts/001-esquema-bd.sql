-- Esquema inicial: eventos deportivos locales
-- Pega este script completo en Supabase → SQL Editor → Run

-- usuarios: perfil ligado 1:1 al usuario de Supabase Auth (auth.users)
create table public.usuarios (
  id uuid primary key references auth.users (id) on delete cascade,
  nombre text not null,
  email text not null,
  ciudad text,
  rol text not null default 'participante' check (rol in ('participante', 'espectador')),
  created_at timestamptz not null default now()
);

-- eventos: partidos/torneos deportivos
create table public.eventos (
  id uuid primary key default gen_random_uuid(),
  nombre text not null,
  deporte text not null,
  fecha date not null,
  hora time not null,
  ciudad text not null,
  lugar text not null,
  cupos_totales integer not null check (cupos_totales >= 0),
  cupos_disponibles integer not null check (cupos_disponibles >= 0),
  descripcion text,
  estado text not null default 'abierto' check (estado in ('abierto', 'cerrado', 'finalizado')),
  created_at timestamptz not null default now()
);

-- reservas: cupos reservados por un usuario para un evento
create table public.reservas (
  id uuid primary key default gen_random_uuid(),
  usuario_id uuid not null references public.usuarios (id) on delete cascade,
  evento_id uuid not null references public.eventos (id) on delete cascade,
  cantidad_cupos integer not null check (cantidad_cupos > 0),
  estado text not null default 'pendiente' check (estado in ('pendiente', 'confirmada', 'cancelada')),
  fecha_reserva timestamptz not null default now()
);

-- tickets: comprobante de una reserva (código/QR simulado)
create table public.tickets (
  id uuid primary key default gen_random_uuid(),
  reserva_id uuid not null unique references public.reservas (id) on delete cascade,
  codigo text not null unique,
  estado text not null default 'valido' check (estado in ('valido', 'usado')),
  created_at timestamptz not null default now()
);

-- índices útiles para los filtros (categoría/fecha/ciudad) y para el historial de reservas
create index idx_eventos_deporte on public.eventos (deporte);
create index idx_eventos_fecha on public.eventos (fecha);
create index idx_eventos_ciudad on public.eventos (ciudad);
create index idx_reservas_usuario_id on public.reservas (usuario_id);
create index idx_tickets_reserva_id on public.tickets (reserva_id);
