//+------------------------------------------------------------------+
//|                                                client_server.mq4 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnStart()
  {
   string auth_plain = "demo:demo";
   string keystr="ABCDEFG";
   
   uchar dst[],src[],key[];
   StringToCharArray(keystr, key);
   StringToCharArray(auth_plain, src);
   string b64_str = CryptDecode(CRYPT_BASE64, src, key, dst);
   printf(b64_str);
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
   httpHeaders = "Authorization: Basic "+b64_str;
   StringToCharArray( "Nothing to post", post );
   
   // GET
   res=WebRequest("GET",server_url,httpHeaders,timeout,post,result,headers);
//--- Checking errors 
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
  }
//+------------------------------------------------------------------+
