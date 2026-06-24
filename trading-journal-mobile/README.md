# Trading Journal — Mobile

Phone-optimized version of the trading journal, deployed as its own site/URL, sharing the same Supabase login and data as the desktop version.

## What's different from the desktop build
- **Hamburger menu** instead of an always-visible sidebar — tap the menu icon top-left to open/close. Tabs still drag-to-reorder inside it.
- **Trade Log defaults to the card/grid view** (easier to read on a narrow screen) instead of the table. The List (table, horizontally scrollable) and Calendar views are still available via the same view-toggle icons.
- All stat grids, modals, and forms collapse to single/double columns and full-screen modals for touch use.
- Same login, same cloud data, same MT5 import, same everything else — this is a responsive variant of the same app, not a separate database.

## Deploy as a separate site
1. Push this folder to its **own GitHub repo** (separate from the desktop one, or a different folder/branch — your call).
2. Import it on **vercel.com/new** as its own project → you'll get its own URL (e.g. `your-journal-mobile.vercel.app`).
3. Sign in there with the same email/password you use on desktop — same trades, accounts, and mantra checklist will be right there.

## One-time setup reminder
If you haven't already run them for the desktop version, you still need:
1. `supabase_setup.sql` — creates the `journal_sync` table.
2. `supabase_auth_migration.sql` — switches to real per-user login security.
3. Create your user in Supabase: Authentication → Users → Add user (with "Auto Confirm User" checked).

These only need to be run once total, on your one Supabase project — not once per deployment.

## Deploy
- **Vercel**: push to GitHub, import at vercel.com/new, no config needed.
- **GitHub Pages**: Settings → Pages → Deploy from branch → main / root.
