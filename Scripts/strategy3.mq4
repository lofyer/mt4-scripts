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

input int watch_period=PERIOD_M1; // Watch period.
input int max_orders=10; //Max number of orders per cycle.
int cycle=watch_period/max_orders;
/*
*  These indexes' relativity can be learned by backtesting.
*/
int buy_index = 0;
int sell_index = 0;

int support = 0;
int resistance = 0;
int correction = 0;

/*
*  MA trade index +-10
*  MA trend index +-10
*/
double MA_Sig(string symbol)
  {
   double cPriceHigh = MarketInfo(symbol, MODE_HIGH);
   double cPriceLow = MarketInfo(symbol,MODE_LOW);
   double cPriceMedian = (cPriceHigh+cPriceLow)/2;
   double cMA = iMA(symbol, watch_period, 14, 0, MODE_SMA, cPriceMedian, 0);
   Print("MA: ", cMA);
   return cMA;
  }

/*
*  MACD trade index +-10
*  MACD trend index +-10
*/
int MACD_Sig(string symbol)
  {
   double MACD_Main=iMACD(symbol,watch_period,12,26,9,iClose(symbol,watch_period,0),MODE_MAIN,0);
   double MACD_Signal=iMACD(symbol,watch_period,12,26,9,iOpen(symbol,watch_period,0),MODE_SIGNAL,0);
   double MACD_Main_shift_1=iMACD(symbol,watch_period,12,26,9,iClose(symbol,watch_period,1),MODE_MAIN,1);
   double MACD_Signal_shift_1=iMACD(symbol,watch_period,12,26,9,iClose(symbol,watch_period,1),MODE_SIGNAL,1);

   Print("MACD main: ", MACD_Main);
   Print("MACD signal: ", MACD_Signal);

/*
* If the MACD line is rising faster than the Signal line and crosses it from below, the signal is interpreted as bullish and suggests acceleration of price growth;
* If the MACD line is falling faster than the Signal line and crosses it from above, the signal is interpreted as bearish and suggests extension of price losses;
*/
   if(((MACD_Main-MACD_Main_shift_1)>(MACD_Signal-MACD_Signal_shift_1)) && (MACD_Main>MACD_Main_shift_1) && (MACD_Main>0))
     {
      Print("36: Time to buy!");
      buy_index += 10;
     }
   if(((MACD_Main-MACD_Main_shift_1)>(MACD_Signal-MACD_Signal_shift_1)) && (MACD_Main<MACD_Main_shift_1) && (MACD_Main<0))
     {
      Print("37: Time to sell!");
      sell_index += 10;
     }
/*
* A bullish signal appears if the MACD line climbs above zero;
* A bearish signal presents if the MACD line falls below zero.
*/
   if((MACD_Main>MACD_Main_shift_1) && (MACD_Main_shift_1>0))
     {
      Print("47: Time to buy!");
      buy_index += 10;
     }
   if((MACD_Main>MACD_Main_shift_1) && (MACD_Main_shift_1<0))
     {
      Print("48: Time to sell!");
      sell_index += 10;
     }
/*      
* If the MACD line is trending in the same direction as the price, the pattern is known as convergence, which confirms the price move;
* If they move in opposite directions, the pattern is divergence. For example, if the price reaches a new high, but the indicator does not, this may be a sign of further weakness.
*/
   return 0;
  }

/*
*  Band +-10
*/

int Bands_Sig(string symbol)
  {
/*
* The increasing distance between the upper and the lower bands while volatility is growing, 
* suggests of a price developing in a trend which direction correlates with the direction of the Middle line.
* In contrast to the above, at times of decreasing volatility when the bands are closing in,
* we should be expecting the price to move sidewards in a range.
*/
   double Band_High = iBands(symbol,0,20,2,0,iLow(symbol,watch_period,0),MODE_UPPER,0);
   double Band_Low = iBands(symbol,0,20,2,0,iLow(symbol,watch_period,0),MODE_LOWER,0);

   double Band_High_shift_1 = iBands(symbol,0,20,2,0,iLow(symbol,watch_period,1),MODE_UPPER,1);
   double Band_Low_shift_1 = iBands(symbol,0,20,2,0,iLow(symbol,watch_period,1),MODE_LOWER,1);
   
   double MA_20 = iMA(symbol, watch_period, 20, 0, MODE_SMA, iLow(symbol,watch_period,0), 0);

   double delta = (Band_High-Band_Low);
   double delta_shift_1 = (Band_High_shift_1-Band_Low_shift_1);
   double price = iLow(symbol,watch_period,0);
   double price_shift_1 = iLow(symbol,watch_period,1);
   
   Print("BAND High: ", Band_High);
   Print("BAND Low: ", Band_Low);
   
   if(delta>delta_shift_1)
     {
      buy_index += 10;
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
      buy_index += 10;
      Print("Bolling Band low U-turn now, time to buy!");
     }

/*
* In a Bollinger Band trading system an uptrend is shown by prices fluctuating between upper and middle bands.
* In such cases if prices cross below the middle band, this warns of a trend reversal to the downside indicating a sell signal.
* In a downtrend, prices fluctuate between middle and lower bands, 
* and the price crossing above the middle band warns of a trend reversal to the upside, indicating a buy signal.
*/
   if((iLow(symbol, watch_period, 0) < MA_20) && (iLow(symbol, watch_period, 1) > MA_20)  && (Band_High > Band_High_shift_1))
   {
      sell_index += 10;
   }
   if((iLow(symbol, watch_period, 0) > MA_20) && (iLow(symbol, watch_period, 1) < MA_20)  && (Band_High < Band_High_shift_1))
   {
      buy_index += 10;
   }
   return 0;
  }

/*
*  Ichimoku trade index +-10
*  Ichimoku trend index +-10
*/
double Ichimoku_Sig(string symbol)
  {
/*
*  Tenkan-Sen (Conversion line, red)
*  Kijun-Sen (Base line, blue)
*  Senkou Span A (Leading span A, red boundary of the cloud)
*  Senkou Span B (Leading span B, purple boundary of the cloud)
*  Chikou Span (Lagging span, green)
*/ 
   double TENKANSEN = iIchimoku(symbol,watch_period, 9, 26, 52, 1, 0);
   double KIJUSEN = iIchimoku(symbol,watch_period, 9, 26, 52, 2, 0);
   double SENKOUSPANA = iIchimoku(symbol,watch_period, 9, 26, 52, 3, 0);
   double SENKOUSPANB = iIchimoku(symbol,watch_period, 9, 26, 52, 4, 0);
   double CHIKOUSPAN = iIchimoku(symbol,watch_period, 9, 26, 52, 5, 0);
   
   double TENKANSEN_shift_1 = iIchimoku(symbol,watch_period, 9, 26, 52, 1, 1);
   double KIJUSEN_shift_1 = iIchimoku(symbol,watch_period, 9, 26, 52, 2, 1);
   double SENKOUSPANA_shift_1 = iIchimoku(symbol,watch_period, 9, 26, 52, 3, 1);
   double SENKOUSPANB_shift_1 = iIchimoku(symbol,watch_period, 9, 26, 52, 4, 1);
   double CHIKOUSPAN_shift_1 = iIchimoku(symbol,watch_period, 9, 26, 52, 5, 1);
    
   //Print("TKENKANSEN: ", TENKANSEN);
    
   return 0;
   
  }

/* 
*  RSI is a relative weak signal. DO NOT OVERDOSE.
*  RSI trade index +-5
*  RSI trend index +-5
*/
double RSI_Sig(string symbol)
  {
   double RSI = iRSI(symbol, watch_period, 14, iClose(symbol,watch_period,0), 0);
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
      //long chart_open = ChartOpen(i, watch_period);
      //ChartApplyTemplate(chart_open, "\\MQL4\mt4_tpl.tpl");
      string cSymbol=SymbolName(i,1);
      Print("Symbol: ", cSymbol);
      Print(MACD_Sig(cSymbol)); 
      for(int j=0; j<=100;j++)
        {
         Print("Symbol: ", cSymbol);
         MA_Sig(cSymbol);
         Bands_Sig(cSymbol);
         Ichimoku_Sig(cSymbol);
         MACD_Sig(cSymbol);
         RSI_Sig(cSymbol);
         Print("Sell index: ", sell_index);
         Print("Buy index: ", buy_index);
         Sleep(1000);
        }

     }
  }
//+------------------------------------------------------------------+
