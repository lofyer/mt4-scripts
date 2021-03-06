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
   // We'll profit 3%-10% and loss 3%-5% of per unit under leverage 100,
   // which means profit $300-1000 every $1000
   // loss $300-500 every $1000
   int leverage = AccountLeverage();
   // the profit and the loss will be determined by watch_all index in the near future
   double profit = 60 * leverage/100; // 5% under leverage 100, 10% under leverage 200
   double loss = 40 * leverage/100;
   for(int j=0;j< SymbolsTotal(1);j++){
      int i = 0;
      while(i<amount){
         //Sleep(100);
         i++;
         double minstoplevel=MarketInfo(SymbolName(j, 1),MODE_STOPLEVEL); 
         Print("Minimum Stop Level=",minstoplevel," points"); 
         if(minstoplevel <= 0.0){
            Print("No stop level defined.");
            minstoplevel = 1;
         }   
         double vBid = MarketInfo(SymbolName(j, 1), MODE_BID);
         double vPoint = MarketInfo(SymbolName(j, 1), MODE_POINT);
         int vDigits = MarketInfo(SymbolName(j, 1), MODE_DIGITS);
         // if you don't want stoploss and takeprofit, just change these to zero
         double stoploss=NormalizeDouble(vBid-(vBid/100)*loss/leverage, vDigits); 
         double takeprofit=NormalizeDouble(vBid+(vBid/100)*profit/leverage, vDigits);
         int order_check = OrderSend(SymbolName(j, 1), OP_BUY, unit, MarketInfo(SymbolName(j, 1), MODE_ASK), 0, stoploss, takeprofit, "Auto Batch Buy", 0, 0, 0);
      }
   }
     
  }
//+------------------------------------------------------------------+
