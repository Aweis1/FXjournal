# Trading Journal

One responsive site (desktop + mobile), real login, cloud sync, MT5 import — plus a new offline note-fault scanner.

## What changed this round
- **Breakdown tab removed entirely** (By strategy, By entry model, By entry type, By attempt, By failure reason lists are gone). Stop-loss hunt stats already moved to Patterns in the previous update and remain there.
- **By day** tab moved later in the default tab order (now sits just before Trade Log). Drag-to-reorder still works exactly as before if you want it elsewhere.
- **Stop-loss hunts** moved from the Breakdown tab into the Patterns tab.
- **New "Faults" tab** — scans every trade note for phrases linked to common self-sabotage (chased entry, forced trade, revenge trade, wrong intention, delusional, etc.), shows a flagged/clean breakdown, lets you filter trades by flag status, and lets you add/remove the detection phrases yourself.

## About the Faults tab — what it actually is
This is **not AI**. It's a plain case-insensitive phrase search against a list you control — no language model, no real understanding of context, no API calls, $0 cost. A note containing "tried to anticipate" gets flagged the same way whether that was a genuine mistake or an offhand remark. Treat flags as "worth rereading," not as a verdict. You can freely add your own trigger phrases (e.g. ones from your own recurring habits) or delete any that produce noise.

## Deploy
- **Vercel**: push to GitHub, import at vercel.com/new, no config needed.
- **GitHub Pages**: Settings → Pages → Deploy from branch → main / root.

## One-time Supabase setup (only once total)
1. SQL Editor → run `supabase_setup.sql`.
2. SQL Editor → run `supabase_auth_migration.sql`.
3. Authentication → Users → Add user (check "Auto Confirm User").

## Linking trades to multiple accounts
The "Linked account" field on each trade is now a multi-select — pick 2, 3, or more of your named accounts on a single trade if you took the same idea across multiple accounts. Each selected account gets its own $ P&L input, since lot sizes/risk often differ by account. Account balances and profit/loss ratios are calculated using each account's own entered amount, not a shared total. Old trades with a single linked account migrate automatically — nothing is lost.

## Sim Lab equity chart — fixed reference lines + breach alerts
The Sim Lab equity curve now shows three flat reference lines: 0R (grey, dashed), -10R floor (red), and 100R ceiling (green), with your actual cumulative R drawn as a distinct solid line on top. The scale auto-expands if your real performance goes beyond -10R or 100R — it never compresses tighter than that range, just stretches further if needed.

The first time your cumulative R crosses below -10R or above 100R, you get an amber ⚠️ alert (a popup plus a banner above the chart that stays until dismissed). It won't spam you again while you remain in breach — only fires again if you recover back across the line and then breach it a second time.

## Confluences vs. Entry Model — now two separate fields
These used to be merged into one field labeled "Confluences" but backed by what was originally meant to be "Entry Model" data. They're now genuinely separate, compact, side-by-side tag pickers on the trade form, each with its own color (amber for Entry Model, blue for Confluences) and their own saved tag lists. Old trades' existing tags were carried forward into Confluences (since that's what they functionally were), leaving Entry Model empty for fresh, correct tagging going forward.

## Deleting wrong tags permanently
Open any tag dropdown (Strategy, Entry Model, Confluences, or Failure Reason) and hover an option — a small trash icon appears. Clicking it permanently removes that tag from your saved list (with a confirmation), so wrong/junk tags don't keep cluttering the picker. This doesn't touch tags already saved on existing trades, only the picker list itself.

## Expandable notes in Table and Grid views
Every trade row/card with a note now shows a small "Text note ▼" toggle. Tap it to expand the full note inline without leaving the table/grid view or opening the edit modal — tap again to collapse.

## New Daily Analysis tab
Pick any specific calendar date (date picker + back/forward arrows) and see: that day's win rate and net R, a trade-by-trade mini chart where each line segment is colored by whether the trade it leads into was a win (green), loss (red), or breakeven (amber), and every note written that day laid out in trade order — so you can see exactly which trade/analysis produced the win R and which produced the loss R, at a glance.

## Weekly review checklist (Daily Analysis tab)
Below the daily notes view, a running list of weeks (Mon-Sun) each with 7 checkboxes — tick a day off once you've actually reviewed its trades. The current week always shows at the top; once all 7 days in a week are checked, that week's card is marked "✓ Reviewed" and visually fades slightly, but it never disappears — past weeks stay visible so you can see your review streak over time. Future days within the current week are locked (can't check ahead). Syncs across devices like everything else.

## Pre-trade analysis template (Note field)
Every time you log a NEW trade, the Note field now pre-fills with a structured analysis template:
- A/B/C: timeframe-by-timeframe breakdown (Daily direction, H4+H1 structure/phase, M15-M5 condition)
- 6 checklist questions (session + medium inducement, liquidity phase, inducement/retail invitation, nearby external zone, premium/discount on H4, proximity to your decisional level)
- A Confluences x Entry Models section with 4 numbered slots to fill in

Just edit the blanks before saving. Editing an *existing* trade still shows that trade's actual saved note, never the blank template — this only pre-fills when starting something new.

## Backtest tab fixes
- **Win % by week** now sorts newest-first (was oldest-first) and caps at 6 weeks by default with a "Show all N weeks" button, instead of growing unbounded as you log more backtests.
- **Setup validity cards** (Valid/Invalid) now show win rate and net R underneath the count, not just a raw number.
- **New breakdowns**: "By entry model" and "By confluences" — win rate and net R for each entry model/confluence tag, scoped to backtest trades only.
- Section labels got emoji for visual consistency with the rest of the app.

## Tab cleanup: Daily Brief and By Day removed
Both tabs were thin/overlapping with other tabs (Daily Brief's risk rating and "best strategy on this day" duplicated what Heatmap and Patterns already covered). They're gone. By Day's net-R-by-weekday chart and day breakdown list weren't discarded — they moved into the top of the Heatmap tab, so that data still lives somewhere.

## Heatmap, upgraded
The heatmap tab now has two toggles:
- **Win % / Net R** — switch the grid's metric. Net R mode colors cells green/red by how much R that day+tag combination actually made or lost, not just win rate.
- **Strategy / Entry model / Confluences** — switch which tag dimension the grid breaks down by, so you can see win rate (or net R) by day × entry model, or day × confluence, not just day × strategy.

Legend updates automatically to match whichever metric is selected.

## 🐛 Fixed: demo data overwriting real synced data
Found and fixed a real bug. Previously, if local browser storage was empty when the app loaded (new device, cleared cache, etc.), it would seed fake demo backtest trades AND save/sync them immediately — before your real cloud data had a chance to load. The merge logic then treated those fake trades as legitimate local data worth keeping, polluting your real account permanently across every device.

Fixed: empty local storage now just starts as a genuinely empty trade list. No fake data is ever created or saved. Cloud sync (on login) is now the only thing that populates a fresh device, exactly as it should have worked from the start. Your cloud data was never deleted by this bug — only mixed with junk — so existing accounts should clean up automatically the next time you log in on each device (the cloud copy stays the source of truth; any old demo trades can simply be deleted from the Trade Log if you spot them).

## Visible sync error banner (no console needed)
Cloud sync failures now show as a clear red banner right at the top of the app — no need to open developer tools or the browser console at all. If the cloud read/write fails for any reason (network issue, permissions, etc.), you'll see exactly what went wrong in plain text, with a dismiss button. This covers all three sync paths: initial load, saving a change, and the periodic background check for updates from other devices.
