//+------------------------------------------------------------------+
//|                                      TradingJournalExporter.mq5   |
//|  Exports closed MT5 trade history to a CSV file that the         |
//|  Trading Journal web app can import via its "Import from MT5"    |
//|  button.                                                          |
//|                                                                    |
//|  HOW TO USE                                                       |
//|  1. Copy this file into:                                          |
//|     MQL5/Experts/TradingJournalExporter.mq5                       |
//|     (In MT5: File > Open Data Folder > MQL5 > Experts)            |
//|  2. Compile it in MetaEditor (F7).                                |
//|  3. Drag it onto any chart as an Expert Advisor.                  |
//|  4. It will write/update a CSV file every EXPORT_INTERVAL_SECONDS |
//|     seconds, and also immediately whenever a trade closes.        |
//|  5. The file is written to:                                       |
//|     MQL5/Files/trading_journal_export.csv                         |
//|     (In MT5: File > Open Data Folder > MQL5 > Files)              |
//|  6. Open the journal web app, go to Trade Log, click              |
//|     "Import from MT5", and select that CSV file.                  |
//|                                                                    |
//|  NOTE ON AUTOMATION                                                |
//|  MT5 cannot push data directly into a browser tab — browsers are  |
//|  sandboxed from the filesystem for security. This script closes   |
//|  the gap by keeping an always-current CSV ready; the import step  |
//|  in the journal is one click, not a full manual re-export each    |
//|  time.                                                             |
//+------------------------------------------------------------------+
#property copyright "Trading Journal Exporter"
#property version   "1.00"
#property strict

input int    EXPORT_INTERVAL_SECONDS = 300;   // Re-export every 5 minutes
input string EXPORT_FILENAME         = "trading_journal_export.csv";
input int    HISTORY_DAYS_BACK       = 365;   // How far back to pull closed trades

datetime lastExportTime = 0;

//+------------------------------------------------------------------+
int OnInit()
{
   ExportTradeHistory();
   EventSetTimer(EXPORT_INTERVAL_SECONDS);
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   EventKillTimer();
}

//+------------------------------------------------------------------+
void OnTimer()
{
   ExportTradeHistory();
}

//+------------------------------------------------------------------+
// Re-export immediately whenever a trade in the account changes
// (e.g. a position closes), not just on the timer.
//+------------------------------------------------------------------+
void OnTradeTransaction(const MqlTradeTransaction& trans,
                         const MqlTradeRequest& request,
                         const MqlTradeResult& result)
{
   if (trans.type == TRADE_TRANSACTION_DEAL_ADD)
   {
      ExportTradeHistory();
   }
}

//+------------------------------------------------------------------+
// Pulls closed deals from account history and writes them to CSV.
// One row per closing deal (DEAL_ENTRY_OUT), which represents a
// completed trade with a realized profit/loss.
//+------------------------------------------------------------------+
void ExportTradeHistory()
{
   datetime fromDate = TimeCurrent() - (HISTORY_DAYS_BACK * 86400);
   datetime toDate   = TimeCurrent() + 86400;

   if (!HistorySelect(fromDate, toDate))
   {
      Print("TradingJournalExporter: HistorySelect failed, error ", GetLastError());
      return;
   }

   int total = HistoryDealsTotal();
   int fileHandle = FileOpen(EXPORT_FILENAME, FILE_WRITE | FILE_CSV | FILE_ANSI, ',');

   if (fileHandle == INVALID_HANDLE)
   {
      Print("TradingJournalExporter: could not open file for writing, error ", GetLastError());
      return;
   }

   // Header row — matches the columns the journal's CSV importer expects
   FileWrite(fileHandle,
      "ticket", "date", "symbol", "type", "volume",
      "entry_price", "exit_price", "sl", "tp",
      "profit", "swap", "commission", "comment", "magic"
   );

   int rowsWritten = 0;

   for (int i = 0; i < total; i++)
   {
      ulong dealTicket = HistoryDealGetTicket(i);
      if (dealTicket == 0) continue;

      long entryType = HistoryDealGetInteger(dealTicket, DEAL_ENTRY);
      // Only export deals that CLOSE a position — these carry the realized P&L
      if (entryType != DEAL_ENTRY_OUT) continue;

      long dealType = HistoryDealGetInteger(dealTicket, DEAL_TYPE);
      // Skip balance/credit operations, only want buy/sell deals
      if (dealType != DEAL_TYPE_BUY && dealType != DEAL_TYPE_SELL) continue;

      datetime dealTime   = (datetime)HistoryDealGetInteger(dealTicket, DEAL_TIME);
      string   symbol     = HistoryDealGetString(dealTicket, DEAL_SYMBOL);
      double   volume     = HistoryDealGetDouble(dealTicket, DEAL_VOLUME);
      double   price      = HistoryDealGetDouble(dealTicket, DEAL_PRICE);
      double   profit     = HistoryDealGetDouble(dealTicket, DEAL_PROFIT);
      double   swap       = HistoryDealGetDouble(dealTicket, DEAL_SWAP);
      double   commission = HistoryDealGetDouble(dealTicket, DEAL_COMMISSION);
      string   comment    = HistoryDealGetString(dealTicket, DEAL_COMMENT);
      long     magic      = HistoryDealGetInteger(dealTicket, DEAL_MAGIC);
      long     posId      = HistoryDealGetInteger(dealTicket, DEAL_POSITION_ID);

      string typeStr = (dealType == DEAL_TYPE_BUY) ? "sell" : "buy";
      // Note: a BUY deal closing a position means the original position was a SELL, and vice versa.
      // We report the direction of the ORIGINAL trade, so we invert here.

      double openPrice = 0;
      double sl = 0, tp = 0;
      // Try to find the matching opening deal for this position to get the open price / SL / TP
      for (int j = 0; j < total; j++)
      {
         ulong otherTicket = HistoryDealGetTicket(j);
         if (otherTicket == 0) continue;
         if (HistoryDealGetInteger(otherTicket, DEAL_POSITION_ID) != posId) continue;
         if (HistoryDealGetInteger(otherTicket, DEAL_ENTRY) == DEAL_ENTRY_IN)
         {
            openPrice = HistoryDealGetDouble(otherTicket, DEAL_PRICE);
            break;
         }
      }

      string dateStr = TimeToString(dealTime, TIME_DATE);
      StringReplace(dateStr, ".", "-");

      FileWrite(fileHandle,
         IntegerToString((int)dealTicket),
         dateStr,
         symbol,
         typeStr,
         DoubleToString(volume, 2),
         DoubleToString(openPrice, _Digits),
         DoubleToString(price, _Digits),
         DoubleToString(sl, _Digits),
         DoubleToString(tp, _Digits),
         DoubleToString(profit, 2),
         DoubleToString(swap, 2),
         DoubleToString(commission, 2),
         comment,
         IntegerToString((int)magic)
      );
      rowsWritten++;
   }

   FileClose(fileHandle);
   lastExportTime = TimeCurrent();
   Print("TradingJournalExporter: exported ", rowsWritten, " closed trades to ", EXPORT_FILENAME);
}
//+------------------------------------------------------------------+
