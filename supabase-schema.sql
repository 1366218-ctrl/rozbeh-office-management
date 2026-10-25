-- روزبه: run this in Supabase SQL Editor for optional multi-device sync.
-- Use Supabase Auth for the single owner. Never place service_role keys in this app.
create table if not exists public.rozbeh_records (
  owner_id uuid not null references auth.users(id) on delete cascade,
  id text not null,
  category text not null check (category in ('customers','items','repairs','invoices','finance')),
  payload jsonb not null,
  updated_at timestamptz not null default now(),
  deleted_at timestamptz null,
  primary key (owner_id, id)
);
alter table public.rozbeh_records enable row level security;
drop policy if exists "owner can read own rozbeh records" on public.rozbeh_records;
drop policy if exists "owner can insert own rozbeh records" on public.rozbeh_records;
drop policy if exists "owner can update own rozbeh records" on public.rozbeh_records;
drop policy if exists "owner can delete own rozbeh records" on public.rozbeh_records;
create policy "owner can read own rozbeh records" on public.rozbeh_records for select to authenticated using (auth.uid() = owner_id);
create policy "owner can insert own rozbeh records" on public.rozbeh_records for insert to authenticated with check (auth.uid() = owner_id);
create policy "owner can update own rozbeh records" on public.rozbeh_records for update to authenticated using (auth.uid() = owner_id) with check (auth.uid() = owner_id);
create policy "owner can delete own rozbeh records" on public.rozbeh_records for delete to authenticated using (auth.uid() = owner_id);
create index if not exists rozbeh_records_owner_category_idx on public.rozbeh_records(owner_id, category);
