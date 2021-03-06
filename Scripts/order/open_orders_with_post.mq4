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

static string api_username = "demo";
static string api_password = "demo";

int postTrade(string data){
   string auth_plain = StringFormat("%s:%s", api_username, api_password);
   string keystr="";
   
   uchar dst[],src[],key[];
   StringToCharArray(keystr, key, 0, StringLen(keystr));
   StringToCharArray(auth_plain, src, 0, StringLen(auth_plain));
   int b64_res = CryptEncode(CRYPT_BASE64, src, key, dst);
   if(b64_res>0) 
     { 
      //--- print encrypted data 
      //PrintFormat("Encoded data: size=%d %s",res,ArrayToHex(dst)); 
      //--- decode dst[] to src[] 
      b64_res = CryptDecode(CRYPT_BASE64,dst,key,src); 
      //--- check error      
      if(b64_res>0) 
        { 
         //--- print decoded data 
         PrintFormat("Decoded data: size=%d, string='%s'",ArraySize(src),CharArrayToString(src)); 
        } 
      else 
         Print("Error in CryptDecode. Error code=",GetLastError()); 
     } 
   else 
      Print("Error in CryptEncode. Error code=",GetLastError());
   string b64_str = CharArrayToString(dst);
   // If you wanna use cookie, please refer add more parameters as HELP says
   string httpHeaders,headers;
   char post[],result[];
   int res;
//--- to enable access to the server, you should add URL "https://www.google.com/finance" 
//--- in the list of allowed URLs (Main Menu->Tools->Options, tab "Expert Advisors"): 
   string server_url="https://api.fusionworks.cn/api/v1/post_trade";
//--- Reset the last error code 
   ResetLastError();
//--- Loading a html page from Google Finance 
   int timeout=5000; //--- Timeout below 1000 (1 sec.) is not enough for slow Internet connection 
   httpHeaders = "Content-Type: application/json \n Authorization: Basic "+b64_str;
   StringToCharArray(data, post, 0, StringLen(data));
   // GET   
   res=WebRequest("POST",server_url,httpHeaders,timeout,post,result,headers);
   if(res==-1)
     {
      Print("Error in WebRequest. Error code  =",GetLastError());
      //--- Perhaps the URL is not listed, display a message about the necessity to add the address 
      MessageBox("Add the address '"+server_url+"' in the list of allowed URLs on tab 'Expert Advisors'","Error",MB_ICONINFORMATION);
     }
   else
     {
      //--- Load successfully 
      Print(CharArrayToString(result));
     }
   return 0;
}

void OnStart()
  {
//---
   // The amount of buy trade per symbol
   int amount = 1;
   double unit = 1;
   // We'll profit 3%-10% and loss 3%-5% of per unit under leverage 100,
   // which means profit $300-1000 every $1000
   // loss $300-500 every $1000
   int leverage = AccountLeverage();
   if(leverage == 0){
      leverage = 10000;
   }
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
         datetime cur_time = TimeCurrent();
         datetime local_time = TimeLocal();
         int order_check = OrderSend(SymbolName(j, 1), OP_BUY, unit, MarketInfo(SymbolName(j, 1), MODE_ASK), 0, stoploss, takeprofit, "Auto Batch Buy", 0, 0, 0);
         if(order_check<0) 
         { 
            Print("OrderSend failed with error #",GetLastError()); 
         } 
         else 
            Print("OrderSend placed successfully"); 
 
         
         if(OrderSelect(order_check, SELECT_BY_TICKET)==true) 
         { 
            string tbp = StringFormat("{'username':'%s', 'account':'%s', 'terminal':'%s', 'account_id':%d, 'order_id':%d, 'symbol':'%s', 'arrive_time':'%s', 'send_time':'%s', 'local_time':'%s', 'type': %d, 'size':%g, 'price':%g, 'slippage':%g, 'stoploss':%g, 'takeprofit':%g, 'taxes':%g, 'swap':%g, 'ma':'%s', 'band':'%s', 'macd':'%s', 'rsi':'%s', 'ichimoku':'%s', 'comment':'%s'}",
               api_username, AccountName(), TerminalName(), AccountNumber(), order_check, OrderSymbol(), TimeToString(OrderOpenTime(), TIME_DATE|TIME_SECONDS), TimeToString(cur_time, TIME_DATE|TIME_SECONDS),TimeToString(local_time, TIME_DATE|TIME_SECONDS), OrderType(), OrderLots(), OrderOpenPrice(), 0, OrderStopLoss(), OrderTakeProfit(), 0, OrderSwap(), "ma", "band", "macd", "rsi", "ichimoku", OrderComment());
            Print(tbp);
            postTrade(tbp);
         } 
         else 
            Print("OrderSelect returned the error of ",GetLastError());
      }
    } 
  }
//+------------------------------------------------------------------+
