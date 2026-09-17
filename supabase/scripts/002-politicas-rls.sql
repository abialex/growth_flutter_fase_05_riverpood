-- Políticas RLS: qué puede hacer cada usuario en cada tabla
-- Pega este script en Supabase → SQL Editor → Run (después de 001-esquema-bd.sql)

-- Asegura que RLS esté activo en las 4 tablas (por si el editor no lo dejó marcado)
alter table public.usuarios enable row level security;
alter table public.eventos enable row level security;
alter table public.reservas enable row level security;
alter table public.tickets enable row level security;

-- ============ usuarios ============
-- cada quien ve y edita solo su propia fila (comparando con el usuario logueado)
create policy "usuarios_select_own"
  on public.usuarios for select
  using (auth.uid() = id);

create policy "usuarios_insert_own"
  on public.usuarios for insert
  with check (auth.uid() = id);

create policy "usuarios_update_own"
  on public.usuarios for update
  using (auth.uid() = id)
  with check (auth.uid() = id);

-- ============ eventos ============
-- lectura pública (con o sin login se puede ver el listado/detalle de eventos)
-- sin política de insert/update/delete: por ahora solo se cargan desde el SQL Editor (como admin)
create policy "eventos_select_public"
  on public.eventos for select
  using (true);

-- ============ reservas ============
-- cada quien ve solo sus propias reservas
create policy "reservas_select_own"
  on public.reservas for select
  using (auth.uid() = usuario_id);

-- Las reservas se crean exclusivamente mediante la RPC crear_reserva.
drop policy if exists "reservas_insert_own" on public.reservas;
revoke insert on public.reservas from anon, authenticated;

-- Las reservas se actualizan exclusivamente mediante RPCs autorizadas.
drop policy if exists "reservas_update_own" on public.reservas;
revoke update on public.reservas from anon, authenticated;

-- ============ tickets ============
-- cada quien ve tickets solo de sus propias reservas
create policy "tickets_select_own"
  on public.tickets for select
  using (
    exists (
      select 1 from public.reservas
      where reservas.id = tickets.reserva_id
        and reservas.usuario_id = auth.uid()
    )
  );

drop policy if exists "tickets_insert_own" on public.tickets;
revoke insert on public.tickets from anon, authenticated;
revoke update on public.tickets from anon, authenticated;
