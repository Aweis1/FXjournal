-- ============================================================
-- Trading Journal — Cloud Sync Table Setup
-- Run this once in Supabase: Dashboard → SQL Editor → New query
-- → paste this whole file → Run.
-- ============================================================

create table if not exists journal_sync (
  sync_id text primary key,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

-- Row Level Security: allow anyone with the correct sync_id to
-- read/write only that row. Since sync_id is derived from a
-- passphrase only you know, this is the access control —
-- there's no separate login system.
alter table journal_sync enable row level security;

create policy "anyone can read their own sync row"
  on journal_sync for select
  using (true);

create policy "anyone can insert their own sync row"
  on journal_sync for insert
  with check (true);

create policy "anyone can update their own sync row"
  on journal_sync for update
  using (true);

-- Auto-update the updated_at timestamp on every write
create or replace function set_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

drop trigger if exists journal_sync_updated_at on journal_sync;
create trigger journal_sync_updated_at
  before update on journal_sync
  for each row
  execute function set_updated_at();
