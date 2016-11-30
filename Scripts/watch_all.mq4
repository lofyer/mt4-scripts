//+------------------------------------------------------------------+
//|                                                   array_test.mq4 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Fusionworks.cn"
#property link      "Fusionworks.cn"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+

input int watch_period=PERIOD_M30; // Watch period.
input int max_orders=10; //Max number of orders per cycle.
int cycle=watch_period/max_orders;
int buy_index = 0;
int sell_index = 0;
int support = 0;
int resistance = 0;

double MA_Sig(string symbol)
  {
   double cPriceHigh = MarketInfo(symbol, MODE_HIGH);
   double cPriceLow=MarketInfo(symbol,MODE_LOW);
   double cPriceMedian=(cPriceHigh+cPriceLow)/2;
   double cMA=iMA(symbol,0,14,0,MODE_SMA,cPriceMedian,0);
   return cMA;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int MACD_Sig(string symbol)
  {
   double MACD_Main=iMACD(symbol,watch_period,12,26,9,iClose(symbol,watch_period,0),MODE_MAIN,0);
   double MACD_Signal=iMACD(symbol,watch_period,12,26,9,iOpen(symbol,watch_period,0),MODE_SIGNAL,0);
   double MACD_Main_shift_1=iMACD(symbol,watch_period,12,26,9,iClose(symbol,watch_period,1),MODE_MAIN,1);
   double MACD_Signal_shift_1=iMACD(symbol,watch_period,12,26,9,iClose(symbol,watch_period,1),MODE_SIGNAL,1);

/*
* If the MACD line is rising faster than the Signal line and crosses it from below, the signal is interpreted as bullish and suggests acceleration of price growth;
* If the MACD line is falling faster than the Signal line and crosses it from above, the signal is interpreted as bearish and suggests extension of price losses;
*/
   if(((MACD_Main-MACD_Main_shift_1)>(MACD_Signal-MACD_Signal_shift_1)) && (MACD_Main>MACD_Main_shift_1) && (MACD_Main>0))
     {
      Alert("36: Time to buy!");
      buy_index+=10;
     }
   if(((MACD_Main-MACD_Main_shift_1)>(MACD_Signal-MACD_Signal_shift_1)) && (MACD_Main<MACD_Main_shift_1) && (MACD_Main<0))
     {
      Alert("37: Time to sell!");
      sell_index+=10;
     }
/*
* A bullish signal appears if the MACD line climbs above zero;
* A bearish signal presents if the MACD line falls below zero.
*/
   if((MACD_Main>MACD_Main_shift_1) && (MACD_Main_shift_1>0))
     {
      Alert("47: Time to buy!");
      buy_index+=5;
     }
   if((MACD_Main>MACD_Main_shift_1) && (MACD_Main_shift_1<0))
     {
      Alert("48: Time to sell!");
      sell_index+=5;
     }
/*      
* If the MACD line is trending in the same direction as the price, the pattern is known as convergence, which confirms the price move;
* If they move in opposite directions, the pattern is divergence. For example, if the price reaches a new high, but the indicator does not, this may be a sign of further weakness.
*/
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int Bands_Sig(string symbol)
  {
/*
* The increasing distance between the upper and the lower bands while volatility is growing, 
* suggests of a price developing in a trend which direction correlates with the direction of the Middle line.
* In contrast to the above, at times of decreasing volatility when the bands are closing in,
* we should be expecting the price to move sidewards in a range.
*/
   double Band_High= iBands(symbol,0,20,2,0,iLow(symbol,watch_period,0),MODE_UPPER,0);
   double Band_Low = iBands(symbol,0,20,2,0,iLow(symbol,watch_period,0),MODE_LOWER,0);

   double Band_High_shift_1= iBands(symbol,0,20,2,0,iLow(symbol,watch_period,1),MODE_UPPER,1);
   double Band_Low_shift_1 = iBands(symbol,0,20,2,0,iLow(symbol,watch_period,1),MODE_LOWER,1);

   double delta=(Band_High-Band_Low);
   double delta_shift_1=(Band_High_shift_1-Band_Low_shift_1);
   double price=iLow(symbol,watch_period,0);
   double price_shift_1=iLow(symbol,watch_period,1);
   if(delta>delta_shift_1)
     {
      Print("Bolling Band delta increasing, time to buy!");
     }
/*   
* The price moving outside the Bands may indicate either the trend’s continuation
* (when the bands are floating apart as the volatility increases) or the U-turn of the trend if the initial movement is exhausted.
* Either way each of the scenarios must be confirmed by other indicators such as RSI,
* ADX or MACD. Anyhow the price crossing of the Middle line from below or above may be interpreted
* as a signal to buy or to sell respectively.
*/
   if((Band_Low_shift_1>Band_Low) && (Band_Low_shift_1<0) && (Band_Low_shift_1>price_shift_1) && (Band_Low<price))
     {
      Print("Bolling Band low U-turn now, time to buy!");
     }

   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double Ichimoku_Sig(string symbol)
  {
/*
   Tenkan-Sen (Conversion line, red)
   Kijun-Sen (Base line, blue)
   Senkou Span A (Leading span A, red boundary of the cloud)
   Senkou Span B (Leading span B, purple boundary of the cloud)
   Chikou Span (Lagging span, green)
*/ 
   double TENKANSEN = iIchimoku(symbol, 9, 26, 52, 1, 0);
   double KIJUSEN = iIchimoku(symbol, 9, 26, 52, 2, 0);
   double SENKOUSPANA = iIchimoku(symbol, 9, 26, 52, 3, 0);
   double SENKOUSPANB = iIchimoku(symbol, 9, 26, 52, 4, 0);
   double CHIKOUSPAN = iIchimoku(symbol, 9, 26, 52, 5, 0);
   
   double TENKANSEN_shift_1 = iIchimoku(symbol, 9, 26, 52, 1, 1);
   double KIJUSEN_shift_1 = iIchimoku(symbol, 9, 26, 52, 2, 1);
   double SENKOUSPANA_shift_1 = iIchimoku(symbol, 9, 26, 52, 3, 1);
   double SENKOUSPANB_shift_1 = iIchimoku(symbol, 9, 26, 52, 4, 1);
   double CHIKOUSPAN_shift_1 = iIchimoku(symbol, 9, 26, 52, 5, 1);
   
   if 
   
   return 0;
   
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double RSI_Sig(string symbol)
  {
   return 0;
  }
  

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
/*
* This section will be run every
*/
   int test_csv = FileOpen("test.csv", FILE_CSV|FILE_WRITE, ',');
   if(test_csv!=INVALID_HANDLE) 
     {
      FileWrite(test_csv,TimeCurrent(),Symbol(),EnumToString(ENUM_TIMEFRAMES(_Period)));
      FileClose(test_csv);
      Print("FileOpen OK");
     }
   else Print("Operation FileOpen failed, error ",GetLastError());
   for(int i=0; i<SymbolsTotal(1); i++)
     {
      string cSymbol=SymbolName(i,1);
      //Alert(cSymbol);
      //Alert(MACD_Sig(cSymbol)); 
      for(int j=0; j<=100;j++)
        {
         //Bands_Sig(cSymbol);
         
         Sleep(5000);
        }

     }
  }
//+------------------------------------------------------------------+
