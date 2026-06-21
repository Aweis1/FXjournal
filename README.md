# Trading Journal

Single-file desktop-only dark-grey + violet trading journal dashboard.

## Theme
Dark charcoal grey base with a shiny violet accent line — active sidebar tab, FAB, save button, toggle switches, and progress bars all use the violet gloss. Profit/loss colors (green/red) stay semantic and untouched so stats remain readable.

## Overview account toggle
The Overview tab has a 🌐 All / 🧪 Sim / 🔴 Live / 🕰️ Backtest segmented toggle. Switching it filters both the stats grid and the equity curve to only that account type.

## Autosave on edit
Opening a trade via the pencil (edit) icon now autosaves continuously as you change any field, tag, or the stop-loss-hunt toggle — no Save button required. New trades (via the + FAB) still require explicit Save, so you don't get half-filled drafts persisted.

## Sidebar
Drag any tab to reorder — order is saved automatically. Desktop-only layout (no mobile breakpoint).

## Data storage
Browser `localStorage` only — persists per device/browser, does not sync across devices.

## Deploy
- **Vercel**: push to GitHub, import at vercel.com/new, no config needed.
- **GitHub Pages**: Settings → Pages → Deploy from branch → main / root.
- **Local**: open `index.html` directly, or `npx serve .`
