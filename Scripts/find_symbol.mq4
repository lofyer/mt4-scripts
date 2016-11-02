//+------------------------------------------------------------------+
//|                                                  find_symbol.mq4 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   ChartOpen("EURUSD-2", PERIOD_H4);
   double vbid = MarketInfo("EURUSD-2", MODE_BID);
   Alert(vbid);
  }
//+------------------------------------------------------------------+
