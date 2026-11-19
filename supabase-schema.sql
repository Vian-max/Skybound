-- Run this in the Supabase SQL Editor for your SKYBOUND project.
-- Each signed-in pilot can access only their own progress row.
create table if not exists public.skybound_progress (
  user_id uuid primary key references auth.users(id) on delete cascade,
  progress jsonb not null,
  updated_at timestamptz not null default now()
);

alter table public.skybound_progress enable row level security;

drop policy if exists "Pilots can read their own progress" on public.skybound_progress;
create policy "Pilots can read their own progress"
  on public.skybound_progress for select to authenticated
  using ((select auth.uid()) = user_id);

drop policy if exists "Pilots can insert their own progress" on public.skybound_progress;
create policy "Pilots can insert their own progress"
  on public.skybound_progress for insert to authenticated
  with check ((select auth.uid()) = user_id);

drop policy if exists "Pilots can update their own progress" on public.skybound_progress;
create policy "Pilots can update their own progress" on public.skybound_progress for update to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

grant select, insert, update on public.skybound_progress to authenticated;
