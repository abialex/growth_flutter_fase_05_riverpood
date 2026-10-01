-- Returns the authenticated user's reservation history with related details.
-- Execute after 004-funciones-rpc.sql and 006-ajustar-rls-usuarios.sql.

create or replace function public.get_my_reservations_with_details()
returns table (
  reservation_id uuid,
  user_id uuid,
  event_id uuid,
  seat_count integer,
  reservation_status text,
  reserved_at timestamptz,
  event_name text,
  event_sport text,
  event_date date,
  event_time time,
  event_city text,
  event_venue text,
  event_total_slots integer,
  event_available_slots integer,
  event_description text,
  event_status text,
  ticket_id uuid,
  ticket_reservation_id uuid,
  ticket_code text,
  ticket_status text,
  ticket_created_at timestamptz
)
language sql
stable
security invoker
set search_path = public, pg_temp
as $$
  select
    r.id as reservation_id,
    r.usuario_id as user_id,
    r.evento_id as event_id,
    r.cantidad_cupos as seat_count,
    r.estado as reservation_status,
    r.fecha_reserva as reserved_at,
    e.nombre as event_name,
    e.deporte as event_sport,
    e.fecha as event_date,
    e.hora as event_time,
    e.ciudad as event_city,
    e.lugar as event_venue,
    e.cupos_totales as event_total_slots,
    e.cupos_disponibles as event_available_slots,
    e.descripcion as event_description,
    e.estado as event_status,
    t.id as ticket_id,
    t.reserva_id as ticket_reservation_id,
    t.codigo as ticket_code,
    t.estado as ticket_status,
    t.created_at as ticket_created_at
  from public.reservas as r
  inner join public.eventos as e on e.id = r.evento_id
  left join public.tickets as t on t.reserva_id = r.id
  where r.usuario_id = auth.uid()
  order by r.fecha_reserva desc;
$$;

revoke execute on function public.get_my_reservations_with_details() from public;
grant execute on function public.get_my_reservations_with_details() to authenticated;
