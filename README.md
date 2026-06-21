# Trading Journal

Single-file desktop dashboard: dark grey + violet theme, account management, MT5 CSV import, and a fully custom mantra checklist.

## MT5 import — why it's CSV, not "live auto-sync"
Browsers can't reach into a desktop application's memory or filesystem — there's no technical path for a web app to "push" data into MT5 or "pull" it automatically without you running something on the MT5 side. The realistic, working setup is:

1. **TradingJournalExporter.mq5** (included) runs *inside* MT5 as an Expert Advisor. It exports your closed trade history to a CSV every 5 minutes (configurable) and instantly whenever a trade closes.
2. In the journal's **Trade Log** tab, click **"📥 Import from MT5 (CSV)"** and select that file. Already-imported trades (matched by MT5 ticket number) are automatically skipped, so you can re-import the same growing file anytime without creating duplicates.

### Installing the MQL5 script
1. In MT5: File → Open Data Folder → MQL5 → Experts. Copy `TradingJournalExporter.mq5` there.
2. Open MetaEditor, open the file, press F7 to compile.
3. Back in MT5, drag the compiled EA onto any chart. Allow it to run (enable algo trading if prompted).
4. It writes `trading_journal_export.csv` into MQL5/Files. That's the file you import in the journal.

## Accounts tab
Add named accounts under Demo, Prop Firm, or Live. Prop Firm accounts take a one-time challenge fee, counted as a loss in that account's P&L and balance. Each account shows current balance, net P&L, and profit/loss ratio (gross $ won ÷ gross $ lost, fee included). Link any trade (manual or imported) to an account via the trade form.

## Mantra tab
Fully your own list now — click any reminder's text to edit it inline, the trash icon to delete it, the input at the bottom to add new ones. "💡 Suggest reminders from my data" appends a few data-driven suggestions without overwriting what you've already written. Checkmarks reset daily; your list itself does not.

## Data storage
Browser `localStorage` only — persists per device/browser, does not sync across devices.

## Deploy
- **Vercel**: push to GitHub, import at vercel.com/new, no config needed.
- **GitHub Pages**: Settings → Pages → Deploy from branch → main / root.
- **Local**: open `index.html` directly, or `npx serve .`
