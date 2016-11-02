//+------------------------------------------------------------------+
//|                                                         test.mq4 |
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
   // The amount of buy trade per symbol
   int amount = 5;
   double unit = 1;
   for(int j=0;j< SymbolsTotal(1);j++){
      int i = 0;
      while(i<amount){
         //Sleep(100);
         i++;
         OrderSend(SymbolName(j, 1), OP_BUY, unit, MarketInfo(SymbolName(j, 1), MODE_BID), 0, 0, 0, "Auto Batch Buy", 0, 0, 0);
      }
   }
     
  }
//+------------------------------------------------------------------+
