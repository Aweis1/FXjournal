# Trading Journal

Single-file dashboard, now behind a **real, server-enforced login** (Supabase Auth) — free, no Vercel Pro needed.

## 🔒 Real login — what changed and why it's actually secure
Before, the whole dashboard rendered immediately, gated only by a client-side passphrase check — bypassable by anyone who opened dev tools. That's gone now. The page now shows **only a login screen** until Supabase's own servers confirm a valid session. Without that, the data API call itself is refused server-side — viewing page source or disabling JavaScript doesn't help, because there's no content to extract in the first place.

### One-time setup (do this once)
1. **Run the migration.** In Supabase: **SQL Editor → New query** → paste `supabase_auth_migration.sql` (included) → Run. This switches the `journal_sync` table from open passphrase access to real per-user ownership (`auth.uid()`-based Row Level Security).
2. **Create your login.** In Supabase: **Authentication → Users → Add user** → enter your email + a password → check **"Auto Confirm User"** (so you skip the email confirmation step) → Create.
3. Deploy/redeploy this `index.html`. Visit the site — you'll see a login screen. Sign in with the email + password from step 2.

That's it — every future visit on any device requires that same email + password.

### What if I never set up the old passphrase-based sync before?
No problem — `supabase_setup.sql` (from the earlier version, also included) still needs to run first if you haven't already, to create the `journal_sync` table at all. Then run `supabase_auth_migration.sql` on top of it.

### Adding more people later
This is currently single-user by design. To add a trusted second person, create another user in **Authentication → Users** — but note they'll get their *own* empty data row (each user only sees their own `owner_id` data), not shared access to yours. Let me know if you want shared multi-user access instead — that's a different RLS setup.

### Signing out
Click the logout icon next to your email at the bottom of the sidebar.

## Trade Log views
List (table) / Grid / Calendar — Date, Pair, Trade type, Status (TP/SL/BE), Account, Trend, Condition, Confluences, Net P&L, Actions.

## MT5 import
`TradingJournalExporter.mq5` (included) auto-exports MT5 closed trades to CSV; import via the Trade Log tab.

## Accounts tab
Demo / Prop Firm / Live named accounts; Prop Firm challenge fee counted as a one-time loss.

## Mantra tab
Fully custom checklist with optional data-driven suggestions.

## Deploy
- **Vercel**: push to GitHub, import at vercel.com/new, no config needed.
- **GitHub Pages**: Settings → Pages → Deploy from branch → main / root.
- **Local**: needs `http(s)://`, not `file://` — use `npx serve .`
