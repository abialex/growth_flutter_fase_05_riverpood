-- Crea automáticamente la fila de perfil en public.usuarios cuando alguien
-- se registra vía Supabase Auth (auth.users). Pega este script en
-- Supabase → SQL Editor → Run (después de 001-esquema-bd.sql y
-- 002-politicas-rls.sql).

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.usuarios (id, nombre, email, ciudad)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'nombre', 'Sin nombre'),
    new.email,
    new.raw_user_meta_data->>'ciudad'
  );
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();
