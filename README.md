# Trading Journal

Single-file desktop dashboard with optional cross-device cloud sync, MT5 CSV import, account management, and a customizable mantra checklist.

## ☁️ Cross-device cloud sync (new)
By default, data still lives only in this browser's `localStorage`. To make it follow you across devices, click **"☁️ Set up cloud sync"** in the sidebar and:

### One-time setup (do this once, on any device)
1. Go to [supabase.com](https://supabase.com) → sign up free → "New project".
2. Once ready: **Project Settings → API** → copy the **Project URL** and the **anon public key**.
3. In Supabase: **SQL Editor → New query** → paste the contents of `supabase_setup.sql` (included here) → Run. This creates the one table the app needs.
4. Back in the journal, paste the URL and key into the sync setup panel, click "Save connection settings".

### Every device after that
Just enter the **same passphrase** in the sync modal and click "Connect & sync now". That's it — no email, no password reset.

### How it works, and its limits
- Your passphrase is hashed (SHA-256) in your browser before anything is sent — the raw passphrase itself never leaves your device.
- Whoever knows the exact passphrase can read/write that data — there's no separate login layer. Don't reuse a sensitive password as your sync passphrase, and don't share it.
- **There is no "forgot passphrase" recovery.** If you lose it, that cloud data is unreachable (though your local copy on each device is unaffected).
- The first time you connect a device with an existing passphrase, local and cloud trades/accounts/mantra are **merged** (nothing is deleted) — after that, the most recent save wins.
- Sync requires HTTPS (Vercel and GitHub Pages both serve over HTTPS by default) — opening the raw HTML file locally via `file://` won't support sync (cloud sync button will simply not connect).
- Every save (new trade, edit, tag, account, mantra change) auto-pushes to the cloud after ~1.2s, and the app polls for changes from other devices every 15s while sync is on.

## Trade Log views
List (table) / Grid / Calendar toggle — Date, Pair, Trade type, Status (TP/SL/BE), Account, Trend, Condition, Confluences, Net P&L, Actions.

## MT5 import
`TradingJournalExporter.mq5` (included) runs as an MT5 Expert Advisor, auto-exporting closed trades to CSV. Import that file from the Trade Log tab — duplicate tickets are skipped automatically.

## Accounts tab
Demo / Prop Firm / Live named accounts, with Prop Firm challenge fees counted as a one-time loss. Shows balance, net P&L, and profit/loss ratio per account.

## Mantra tab
Fully custom checklist — add, inline-edit, delete your own reminders; an optional button appends data-driven suggestions without overwriting anything you've written.

## Deploy
- **Vercel**: push to GitHub, import at vercel.com/new, no config needed.
- **GitHub Pages**: Settings → Pages → Deploy from branch → main / root.
- **Local**: open `index.html` directly (cloud sync won't work over `file://`), or better, `npx serve .` and open via `http://localhost`.
