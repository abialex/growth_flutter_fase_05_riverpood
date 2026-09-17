-- Funciones transaccionales de Supabase.
-- Ejecutar después de 001-esquema-bd.sql, 002-politicas-rls.sql y
-- 003-trigger-usuarios.sql, antes de probar el flujo de reservas.
-- Este archivo es la fuente actual de verdad para las reservas y compras.

-- Crea una reserva validando autenticación, estado y cupos del evento.
create or replace function public.crear_reserva(
  p_evento_id uuid,
  p_cantidad_cupos integer
)
returns setof public.reservas
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_evento public.eventos;
  v_reserva public.reservas;
  v_usuario_id uuid := auth.uid();
begin
  if v_usuario_id is null then
    raise exception using
      errcode = '42501',
      message = 'Authentication is required to create a reservation.';
  end if;

  if p_cantidad_cupos is null or p_cantidad_cupos <= 0 then
    raise exception using
      errcode = 'P0001',
      message = 'The requested seat count is invalid.';
  end if;

  select *
  into v_evento
  from public.eventos
  where id = p_evento_id
  for update;

  if not found then
    raise exception using
      errcode = 'P0002',
      message = 'The event does not exist.';
  end if;

  if v_evento.estado <> 'abierto' then
    raise exception using
      errcode = 'P0003',
      message = 'The event is not open for reservations.';
  end if;

  if v_evento.cupos_disponibles < p_cantidad_cupos then
    raise exception using
      errcode = 'P0004',
      message = 'There are not enough available seats.';
  end if;

  if exists (
    select 1
    from public.reservas
    where usuario_id = v_usuario_id
      and evento_id = p_evento_id
      and estado in ('pendiente', 'confirmada')
  ) then
    raise exception using
      errcode = '23505',
      message = 'The user already has an active reservation for this event.';
  end if;

  update public.eventos
  set cupos_disponibles = cupos_disponibles - p_cantidad_cupos
  where id = p_evento_id;

  insert into public.reservas (
    usuario_id,
    evento_id,
    cantidad_cupos,
    estado
  )
  values (
    v_usuario_id,
    p_evento_id,
    p_cantidad_cupos,
    'pendiente'
  )
  returning * into v_reserva;

  return next v_reserva;
end;
$$;

revoke execute on function public.crear_reserva(uuid, integer) from public;
grant execute on function public.crear_reserva(uuid, integer) to authenticated;

-- Confirma una reserva y crea su ticket dentro de una única transacción.
-- Current reservation transition: pending -> confirmed.
-- Cancellation is not exposed until its cup-restoration flow is defined.
create or replace function public.confirmar_compra(
  p_reserva_id uuid
)
returns setof public.tickets
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_reserva public.reservas;
  v_ticket public.tickets;
  v_usuario_id uuid := auth.uid();
begin
  if v_usuario_id is null then
    raise exception using
      errcode = '42501',
      message = 'Authentication is required to confirm a purchase.';
  end if;

  select *
  into v_reserva
  from public.reservas
  where id = p_reserva_id
    and usuario_id = v_usuario_id
  for update;

  if not found then
    raise exception using
      errcode = 'P0006',
      message = 'The reservation does not exist or does not belong to the user.';
  end if;

  if v_reserva.estado <> 'pendiente' then
    raise exception using
      errcode = 'P0005',
      message = 'The reservation cannot be confirmed in its current state.';
  end if;

  update public.reservas
  set estado = 'confirmada'
  where id = p_reserva_id;

  insert into public.tickets (
    reserva_id,
    codigo,
    estado
  )
  values (
    p_reserva_id,
    'TCK-' || replace(gen_random_uuid()::text, '-', ''),
    'valido'
  )
  returning * into v_ticket;

  return next v_ticket;
end;
$$;

revoke execute on function public.confirmar_compra(uuid) from public;
grant execute on function public.confirmar_compra(uuid) to authenticated;

-- Evita que un cliente omita las validaciones de las RPCs con operaciones directas.
drop policy if exists "reservas_insert_own" on public.reservas;
revoke insert on public.reservas from anon, authenticated;
drop policy if exists "reservas_update_own" on public.reservas;
revoke update on public.reservas from anon, authenticated;
drop policy if exists "tickets_insert_own" on public.tickets;
revoke insert on public.tickets from anon, authenticated;
revoke update on public.tickets from anon, authenticated;
