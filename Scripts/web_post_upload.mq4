//+------------------------------------------------------------------+
//|                                              web_post_upload.mq4 |
//|                                                   fusionworks.cn |
//|                                               www.fusionworks.cn |
//+------------------------------------------------------------------+
#property copyright "fusionworks.cn"
#property link      "www.fusionworks.cn"
#property version   "1.00"
#property strict
#property script_show_inputs 
#property description "Sample script posting a user message " 
  
input string InpLogin   ="";             //Your MQL5.com account 
input string InpPassword="";             //Your account password 
input string InpFileName="EURUSDM5.png"; //An image in folder MQL5/Files/ 
input string InpFileType="image/png";    //Correct mime type of the image 
//+------------------------------------------------------------------+ 
//| Posting a message with an image on the wall at mql5.com          | 
//+------------------------------------------------------------------+ 
bool PostToNewsFeed(string login,string password,string text,string filename,string filetype) 
  { 
   int    res;     // To receive the operation execution result 
   char   data[];  // Data array to send POST requests 
   char   file[];  // Read the image here 
   string str="Login="+login+"&Password="+password; 
   string auth,sep="-------Jyecslin9mp8RdKV"; // multipart data separator 
//--- A file is available, try to read it 
   if(filename!=NULL && filename!="") 
     { 
      res=FileOpen(filename,FILE_READ|FILE_BIN); 
      if(res<0) 
        { 
         Print("Error opening the file \""+filename+"\""); 
         return(false); 
        } 
      //--- Read file data 
      if(FileReadArray(res,file)!=FileSize(res)) 
        { 
         FileClose(res); 
         Print("Error reading the file \""+filename+"\""); 
         return(false); 
        } 
      //--- 
      FileClose(res); 
     } 
//--- Create the body of the POST request for authorization 
   ArrayResize(data,StringToCharArray(str,data,0,WHOLE_ARRAY,CP_UTF8)-1); 
//--- Resetting error code 
   ResetLastError(); 
//--- Authorization request 
   res=WebRequest("POST","https://www.mql5.com/en/auth_login",NULL,0,data,data,str); 
//--- If authorization failed 
   if(res!=200) 
     { 
      Print("Authorization error #"+(string)res+", LastError="+(string)GetLastError()); 
      return(false); 
     } 
//--- Read the authorization cookie from the server response header 
   res=StringFind(str,"Set-Cookie: auth="); 
//--- If cookie not found, return an error 
   if(res<0) 
     { 
      Print("Error, authorization data not found in the server response (check login/password)"); 
      return(false); 
     } 
//--- Remember the authorization data and form the header for further requests 
   auth=StringSubstr(str,res+12); 
   auth="Cookie: "+StringSubstr(auth,0,StringFind(auth,";")+1)+"\r\n"; 
//--- If there is a data file, send it to the server 
   if(ArraySize(file)!=0) 
     { 
      //--- Form the request body 
      str="--"+sep+"\r\n"; 
      str+="Content-Disposition: form-data; name=\"attachedFile_imagesLoader\"; filename=\""+filename+"\"\r\n"; 
      str+="Content-Type: "+filetype+"\r\n\r\n"; 
      res =StringToCharArray(str,data); 
      res+=ArrayCopy(data,file,res-1,0); 
      res+=StringToCharArray("\r\n--"+sep+"--\r\n",data,res-1); 
      ArrayResize(data,ArraySize(data)-1); 
      //--- Form the request header 
      str=auth+"Content-Type: multipart/form-data; boundary="+sep+"\r\n"; 
      //--- Reset error code 
      ResetLastError(); 
      //--- Request to send an image file to the server 
      res=WebRequest("POST","https://www.mql5.com/upload_file",str,0,data,data,str); 
      //--- check the request result 
      if(res!=200) 
        { 
         Print("Error sending a file to the server #"+(string)res+", LastError="+(string)GetLastError()); 
         return(false); 
        } 
      //--- Receive a link to the image uploaded to the server 
      str=CharArrayToString(data); 
      if(StringFind(str,"{\"Url\":\"")==0) 
        { 
         res     =StringFind(str,"\"",8); 
         filename=StringSubstr(str,8,res-8); 
         //--- If file uploading fails, an empty link will be returned 
         if(filename=="") 
           { 
            Print("File sending to server failed"); 
            return(false); 
           } 
        } 
     } 
//--- Create the body of a request to post an image on the server 
   str ="--"+sep+"\r\n"; 
   str+="Content-Disposition: form-data; name=\"content\"\r\n\r\n"; 
   str+=text+"\r\n"; 
//--- The languages in which the post will be available on mql5.com  
   str+="--"+sep+"\r\n"; 
   str+="Content-Disposition: form-data; name=\"AllLanguages\"\r\n\r\n"; 
   str+="on\r\n"; 
//--- If the picture has been uploaded on the server, pass its link 
   if(ArraySize(file)!=0) 
     { 
      str+="--"+sep+"\r\n"; 
      str+="Content-Disposition: form-data; name=\"attachedImage_0\"\r\n\r\n"; 
      str+=filename+"\r\n"; 
     } 
//--- The final string of the multipart request 
   str+="--"+sep+"--\r\n"; 
//--- Out the body of the POST request together in one string 
   StringToCharArray(str,data,0,WHOLE_ARRAY,CP_UTF8); 
   ArrayResize(data,ArraySize(data)-1); 
//--- Prepare the request header   
   str=auth+"Content-Type: multipart/form-data; boundary="+sep+"\r\n"; 
//--- Request to post a message on the user wall at mql5.com 
   res=WebRequest("POST","https://www.mql5.com/ru/users/"+login+"/wall",str,0,data,data,str); 
//--- Return true for successful execution 
   return(res==200); 
  } 
//+------------------------------------------------------------------+ 
//| Script program start function                                    | 
//+------------------------------------------------------------------+ 
void OnStart() 
  { 
//--- Post a message on mql5.com, including an image, the path to which is taken from the InpFileName parameter 
   PostToNewsFeed(InpLogin,InpPassword,"Checking the expanded version of WebRequest\r\n" 
                  "(This message has been posted by the WebRequest.mq5 script)",InpFileName,InpFileType); 
  } 
//+------------------------------------------------------------------+
