//+------------------------------------------------------------------+
//|                                                    close_all.mq4 |
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
   while(OrdersTotal() != 0){
      for(int i=0;i<OrdersTotal();i++){
         if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES)){
            double tAsk = MarketInfo(OrderSymbol(), MODE_ASK);
            OrderClose(OrderTicket(), 1, tAsk, 0, 0);
         }
         //Alert(GetLastError());   
         //Sleep(200);
      }
   }
  }
//+------------------------------------------------------------------+
