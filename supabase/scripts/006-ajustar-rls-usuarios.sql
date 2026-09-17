-- Reapplies the user update policy with explicit row checks.
-- Run after the initial Supabase scripts when the policy already exists.

drop policy if exists "usuarios_update_own" on public.usuarios;

create policy "usuarios_update_own"
  on public.usuarios for update
  using (auth.uid() = id)
  with check (auth.uid() = id);
