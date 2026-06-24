-- ============================================================
-- Trading Journal — Upgrade to real login (Supabase Auth)
-- Run this ONCE in Supabase: Dashboard → SQL Editor → New query
-- → paste this whole file → Run.
--
-- This replaces the old "anyone with the right sync_id" policies
-- with real ownership: each row is tied to the specific logged-in
-- user (auth.uid()) who created it. Without a valid login session,
-- Supabase's own servers refuse the request — this is enforced
-- outside the browser, so it can't be bypassed by viewing source
-- or disabling JavaScript.
-- ============================================================

-- Add a column to track which authenticated user owns each row.
alter table journal_sync
  add column if not exists owner_id uuid references auth.users(id);

-- Drop the old open-access policies from the passphrase-only setup.
drop policy if exists "anyone can read their own sync row" on journal_sync;
drop policy if exists "anyone can insert their own sync row" on journal_sync;
drop policy if exists "anyone can update their own sync row" on journal_sync;

-- New policies: only the authenticated owner can read/write their row.
create policy "owner can read their row"
  on journal_sync for select
  using (auth.uid() = owner_id);

create policy "owner can insert their row"
  on journal_sync for insert
  with check (auth.uid() = owner_id);

create policy "owner can update their row"
  on journal_sync for update
  using (auth.uid() = owner_id);

-- ============================================================
-- One-time step: create your login.
-- Go to Supabase Dashboard → Authentication → Users → Add user
-- → enter your email + a password → make sure "Auto Confirm User"
-- is checked (so you don't need to click an email confirmation link).
-- That's your one and only login for the app.
-- ============================================================
