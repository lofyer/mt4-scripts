//+------------------------------------------------------------------+
//|                                                   find_close.mq4 |
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
   // Lot
   int unit = 1;
  
   // The profit per trades.
   double profit = 50;
   double loss = 30;
   
   // Time to respawn in seconds;
   int respawn = 5;
   
   while(true){
      for(int i = 0; i < OrdersTotal(); i++){
         if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES)==True){
            if(OrderProfit() > profit){
               double tAsk = MarketInfo(OrderSymbol(), MODE_ASK);
               OrderClose(OrderTicket(), unit, tAsk, 0);
            }
            if(MathAbs(OrderProfit()) > loss){
               double tAsk = MarketInfo(OrderSymbol(), MODE_ASK);
               OrderClose(OrderTicket(), unit, tAsk, 0);
            }
         }
      }
      Sleep(respawn * 1000);
   }
  }
//+------------------------------------------------------------------+
