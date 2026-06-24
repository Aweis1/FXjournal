# Trading Journal

One site, one URL, one Vercel project — responsive across desktop and mobile.

## What changed
Previously this was two separate deployments (desktop + mobile), each its own Vercel project and URL. They've now been merged into a single `index.html` that automatically adapts:
- **Wide screens** → full sidebar, table/grid/calendar trade log, multi-column stat grids.
- **Narrow screens (≤860px)** → hamburger menu (slide-out sidebar drawer), card-based trade log by default, single/double-column stat grids, full-screen modals.

Both were already pointed at the same Supabase login and data — that part never needed merging. This change only consolidates the *deployment*, not the storage.

## Cleaning up the old duplicate Vercel projects
If you haven't already:
1. Go to vercel.com → open each extra project you no longer need.
2. Settings → scroll to the bottom → **Delete Project** → confirm.
3. Keep only the one project that will now serve this unified `index.html`. Update its repo connection (or just push this file to whichever repo it's already watching) and redeploy.

## One-time Supabase setup (only ever needs to happen once, regardless of deployments)
1. SQL Editor → run `supabase_setup.sql`.
2. SQL Editor → run `supabase_auth_migration.sql`.
3. Authentication → Users → Add user (check "Auto Confirm User").

## Deploy
- **Vercel**: push to GitHub, import at vercel.com/new (or redeploy your existing project), no config needed — Root Directory stays at the repo root.
- **GitHub Pages**: Settings → Pages → Deploy from branch → main / root.
