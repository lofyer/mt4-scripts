//+------------------------------------------------------------------+
//|                                                      test_ea.mq4 |
//|                                                   fusionworks.cn |
//|                                               www.fusionworks.cn |
//+------------------------------------------------------------------+
#property copyright "fusionworks.cn"
#property link      "www.fusionworks.cn"
#property version   "1.00"
#property strict
//--- input parameters
input int      watch_period=30;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
   EventSetTimer(1);
   //EventSetMillisecondTimer(10);
      
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
   EventKillTimer();
      
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   static int tick_count = 0;
   tick_count += 1;
   Print("This is a tick: ", tick_count);
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
   static int time_count = 0;
   time_count += 1;
   Print("This is a timer: ", time_count);
  }
//+------------------------------------------------------------------+
//| Tester function                                                  |
//+------------------------------------------------------------------+
double OnTester()
  {
//---
   double ret=0.0;
//---
   Print("This is a tester.");
//---
   return(ret);
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---
   Print("This is a charevent:", id);
  }
//+------------------------------------------------------------------+
