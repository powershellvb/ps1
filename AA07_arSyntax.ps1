﻿<#

\\172.16.220.29\c$\Users\administrator.CSD\OneDrive\download\PS1\AA07_arSyntax.ps1


$ps1fS=gi C:\Users\administrator.CSD\OneDrive\download\ps1\AA07_arSyntax.ps1

foreach ($ps1f in $ps1fS)
{
    start-sleep 1
    $ps1fname         =$ps1fS.name
    $ps1fFullname     =$ps1fS.FullName 
    $ps1flastwritetime=$ps1fS.LastWriteTime
    $getdagte         = get-date -format yyyyMMdd
    $ps1length        =$ps1fS.Length

    Send-MailMessage -SmtpServer  '172.16.200.27'  -To "a0921887912@gmail.com","abcd12@gmail.com" -from 'a0921887912@gmail.com' `
    -attachment $ps1fFullname  `
    -Subject "ps1source  -- $getdagte      --        $ps1fname       --   $ps1flastwritetime -- $ps1length " `
    -Body "  ps1source from:me $ps1fname   " 
}


#>

# 39  變數（variable）
# 59  運算子
# 77  常數（constant）
# 84  前置處理指令
# 106    flow control  I/O 開關操作    類比輸入 類比輸出
# 116 字元
# 128 字串
# 141 函數（function）
# 152 條件敘述
# 165 陣列
# 175 延時指令
# 184 程式記憶體（program memory）
# 195 埠口（Port）
# 204 中斷處理
# 215 未分類指令
# 222 網頁HTML語法
# 243 未分類程式庫
# 252 ArduinoNunchuk.h （Wii左手把程式庫）
# 265 DHT11（溫濕度感測器程式庫）
# 272 Ethernet.h（官方以太網路程式庫）  
# 287 Firmata（通用訊息格式程式庫）
# 302 IRremote（紅外線遙控程式庫）
# 309 LiquidCrystal.h（LCD顯示模組控制）
# 328 Serial.h（序列通訊程式庫）
# 338 Servo.h（伺服馬達程式庫）
# 345 SPI.h（SPI界面程式庫）
# 360 Wire.h（I2C/TWI介面通訊程式庫）
# 373 WebServer.h（Webduino程式庫）
#>}第二版內容更新說明    http://swf.com.tw/?p=622#--------------------------------------------------------------------------------
#  39 變數（variable）
#--------------------------------------------------------------------------------

變數（variable）	3-14, 3-15, 3-16
有效範圍（scope）	8-7
全域（global）	8-8, 8-9
區域（local）	8-8
volatile關鍵字	D-7
資料類型	3-17, 3-18
轉換資料類型	3-19, 3-20, 9-22, 9-24
L, U, UL格式字元	3-19 element 中修改 ext LinerLayout to RelativeLayout
程式畫面放大  <左下角>







#--------------------------------------------------------------------------------
#  59  運算子
#--------------------------------------------------------------------------------

%（餘除）	11-16
&（AND，「及」運算子）	10-9, 11-26, 11-27
|（OR，「或」運算子）	10-9, 11-27
~（NOT，「反相」運算子）	11-26, 11-27
^（XOR，異或，邏輯互斥）	11-25, D-13
<<, >>（位移運算子）	4-29, 4-30, 11-26, 11-27








#--------------------------------------------------------------------------------
#   77 常數（constant）
#--------------------------------------------------------------------------------
常數（constant）	3-24, 3-25, 8-30, 8-38
系統預設常數（INPUT, OUTPUT, HIGH, LOW, true, false）


#--------------------------------------------------------------------------------
# 84 前置處理指令
#--------------------------------------------------------------------------------

#define，巨集指令替換資料	13-7
#include，引用程式庫	8-23, 8-38, 9-6, 13-10


#--------------------------------------------------------------------------------
#  106    flow control  I/O 開關操作    類比輸入 類比輸出
#--------------------------------------------------------------------------------


pinMode()，設定接腳模式	3-4, 4-21, 4-22, 4-24
digitalWrite()，數位輸出	3-5
digitalRead()，讀取數位輸入值	4-6
消除彈跳（debounce）	4-15

類比輸入腳位	6-2
類比取樣與量化	6-3
analogRead()，類比訊號輸入	6-3, 6-17, 10-6v

類比輸出腳位∕頻率	10-5
analogWrite()，類比訊號輸出	10-4, 10-7
map()，調整數值範圍	10-6, 11-8
PWM（脈寬調變）	10-3
PWM輸出電壓計算式	10-4
改變PWM的輸出頻率	10-9




#--------------------------------------------------------------------------------
#   116 字元
#--------------------------------------------------------------------------------

字串設定語法	5-13
ASCII字元	5-11, 5-12, 5-21, 8-39
NULL, ‘\0’	5-12, 5-14, 8-14, 17-17
\n (Newline)，「新行」字元	5-16, 9-10, 10-10, 10-12, 10-13, 11-14, 11-15, 11-32, 17-7, 17-22
CR, LF字元	5-12, 5-13, 5-22（序列埠監控視窗）



#--------------------------------------------------------------------------------
# 128  字串
#--------------------------------------------------------------------------------
字串設定語法	5-15, 9-10
strcmp()，比較字串	16-29
strlen()，取得字串長度	16-33
字串轉數字	11-16, 16-15
atoi()，字串轉數字函數	10-12, 17-24, 17-25
String程式庫	17-19
Streaming程式庫	16-8, 16-13
dtostrf()，數字轉字串	16-15


#--------------------------------------------------------------------------------
#  141  函數（function）
#--------------------------------------------------------------------------------
自訂函數	8-3, 8-5, 9-30
void	8-4
參數（引數）	8-4
return	8-4, 8-5, 9-30
函數原型（function prototype）	8-6
回呼函數（callback function）	17-29


#--------------------------------------------------------------------------------
#   152  條件敘述
#--------------------------------------------------------------------------------

f…else…	4-8, 5-23
比較運算子（==, <, >, !, !=）	4-10
邏輯運算子（!, &&, ||）	6-18, 4-11, 10-13, 11-25, 11-32
switch…case…	5-23
break	5-23, 5-24, 18-17
while迴圈	4-21
do…while迴圈	4-22
for迴圈	4-23, 4-24, 8-26, 8-27, 8-35
雙重迴圈	8-27, 8-29, 8-30
#--------------------------------------------------------------------------------
#  165 陣列
#--------------------------------------------------------------------------------

陣列	4-26, 7-3, 7-4, 8-35, 8-41, 9-10, 9-11, 12-17, 17-25
多維（二維）陣列	8-29, 8-30, 8-33, 8-38, 8-39, 9-13, 18-15
sizeOf()	4-26, 8-35, 17-25
指標（*, &）	8-39, 8-40, 8-41, 8-42


#--------------------------------------------------------------------------------
#   175 延時指令
#--------------------------------------------------------------------------------

delay()	3-6
delayMicroseconds()	3-7
millis()	6-19, 6-20, 8-19, 13-39
micros()	13-39

#--------------------------------------------------------------------------------
#   184  程式記憶體（program memory）
#--------------------------------------------------------------------------------
程式記憶體（program memory）	1-11, 3-24, 18-15, 18-19
pgmspace.h（程式儲存空間指令集）	8-42, 18-15, 18-17
PROGMEM	3-27, 8-38, 18-15, 18-17
pgm_read_byte()，讀取程式記憶體區的資料	8-42, 8-43
printP()，輸出存在程式記憶體區的字串	16-4, 16-7, 16-13
p()，將字串寫入程式記憶體區	16-3, 16-6, 16-12
memcmp(), memcmp_P()，比較陣列值	18-16

#--------------------------------------------------------------------------------
#  195  埠口（Port）
#--------------------------------------------------------------------------------

埠口	4-28, 17-35
PORTB	4-29, 4-30
DDRB	4-28, 4-30
DDRD	7-6, 7-7
PORTD	7-7
#--------------------------------------------------------------------------------
#  204 中斷處理
#--------------------------------------------------------------------------------

中斷處理	D-2
外部中斷腳位	D-3
中斷觸發時機	D-4
中斷服務常式（ISR） D-4
attachInterrupt(), 啟用中斷功能	D-5


#--------------------------------------------------------------------------------
#   215 未分類指令
#--------------------------------------------------------------------------------

random(), 隨機數字	10-7
randomSeed()，初始化隨機數字	10-8

#--------------------------------------------------------------------------------
#  222  網頁HTML語法
#--------------------------------------------------------------------------------

HTML語法	15-14
URL編碼	16-22
doctype ，文件類型定義	15-16
<html>，根元素	15-16
<head>，檔頭	15-16
<title>，標題	15-16
<body>，內文	15-16
<p>，段落	15-15
<br>，斷行	15-15
<img>，影像	16-9
<a>，超連結	16-10
<meta>，描述網頁資料	15-16, 16-17
<form>，表單	16-18, 16-26
<input>，表單輸入元素	16-18, 16-19
XML	18-22


#--------------------------------------------------------------------------------
#  243 未分類程式庫
#--------------------------------------------------------------------------------

程式庫	5-15
IRremote.h	12-9,	12-14
SoftwareSerial.h，軟體序列通訊程式庫	14-10, 18-12


#--------------------------------------------------------------------------------
# 252  ArduinoNunchuk.h （Wii左手把程式庫）
#--------------------------------------------------------------------------------
rduinoNunchuk.h（Wii左手把程式庫）	11-20, 11-21
init()，初始化左手把	11-21
analogX，類比X值	11-21, 11-23
analogY，類比Y值	11-21, 11-23
accelX，加速度X值	11-21, 11-23
accelY，加速度Y值	11-21, 11-23
accelZ，加速度Z值	11-21
zButton，Z按鈕值	11-21
cButton，C按鈕值	11-21

#--------------------------------------------------------------------------------
#  265 DHT11（溫濕度感測器程式庫）
#--------------------------------------------------------------------------------
DHT11（溫濕度感測器程式庫）	9-20
read()，讀取感測資料	9-21, 9-22, 9-24
temperature()，讀取溫度值	9-21, 9-22, 9-24
humidity()，讀取濕度值	9-21, 9-22, 9-24
#--------------------------------------------------------------------------------
# 272  Ethernet.h（官方以太網路程式庫）  
#--------------------------------------------------------------------------------

Ethernet.h（以太網路程式庫）	15-25, 15-28
IPAddress，IP位址資料類型	15-25
EthernetServer。以太網路伺服器類別	15-25
EthernetClient，以太網路用戶端類別	15-26
Ethernet.begin()，啟動以太網路連線	15-25
Ethernet.localIP()，傳回伺服器端的IP位址	15-28
connected()，確認是否已建立連線	15-26
available()，確認用戶端是否存在	15-26
stop()，終止連線	15-26


#--------------------------------------------------------------------------------
#  287  Firmata（通用訊息格式程式庫）
#--------------------------------------------------------------------------------

Firmata（通用訊息格式程式庫）
Firmata（通用訊息格式程式庫）	17-28
begin()，初始化連線	17-33
setFirmwareVersion()，設定韌體版本	17-30
IS_PIN_PWM()，檢查腳位是否支援PWM	17-30
IS_PIN_DIGITAL()，檢查是否為數位腳	17-35
analogWriteCallback()，類比訊息回呼函數	17-29
digitalWriteCallback()，數位訊息回呼函數	17-29
sendAnalog()，傳送類比資料	17-33
SET_PIN_MODE，設定腳位模式	17-38
writePort()，輸出數位值	17-36
#--------------------------------------------------------------------------------
# 302 IRremote（紅外線遙控程式庫）
#--------------------------------------------------------------------------------

IRremote，紅外線遙控程式庫	12-9, 12-14
SoftwareSerial.h，軟體序列通訊程式庫	14-10
Streaming，輸出字串程式庫	16-8, 16-13
#--------------------------------------------------------------------------------
# 309  LiquidCrystal.h（LCD顯示模組控制）
#--------------------------------------------------------------------------------


LiquidCrystal.h（LCD顯示模組控制）	9-6, 9-23
LiquidCrystal_SR.h（串接式LCD顯示模組控制）	9-6, 9-23
home()，讓游標回到原點	9-7
setCursor() ，設定游標位置	9-7, 9-23
clear()，清除畫面並重設游標位置	9-7
display(), noDisplay()	9-14
print()，輸出顯示文字	9-7, 9-23
cursor(), noCursor()	9-7
blink(), noBlink	9-7, 9-14
rightToLeft()，從右到左顯示	9-9
autoScroll()，自動捲動	9-9
CGROM，顯示特殊符號與日文片假名	9-9
CGRAM，顯示自訂字元符號	9-11

#--------------------------------------------------------------------------------
# 328   Serial.h（序列通訊程式庫）
#--------------------------------------------------------------------------------


available()，檢查是否有資料	5-19
begin()，初始化連線	5-15
print(), println()，輸出字串	5-16, 5-18（格式轉換）
read()，讀取序列文字	5-20, 10-13
write()，輸出字元	11-8, 11-13, 13-26
#--------------------------------------------------------------------------------
# 338  Servo.h（伺服馬達程式庫）
#--------------------------------------------------------------------------------


Servo.h（伺服馬達程式庫）	11-8
attach()，設定接腳	11-8, 11-31, 11-32
write()，設定旋轉角度	11-8, 11-31, 11-32
#--------------------------------------------------------------------------------
# 345  SPI.h（SPI界面程式庫）
#--------------------------------------------------------------------------------


SPI.h（SPI界面程式庫）	8-20, 8-23
begin()，初始化連線	8-23
transfer()，傳送資料	8-20
setDataMode()，設定資料模式	8-44
setBitOrder()，設定位元傳輸順序	8-44
setClockDivider()，設定頻率	8-44
MSBFIRST，高位元先傳	8-43, 8-44
LSBFIRST，低位元先傳	8-43

#--------------------------------------------------------------------------------
#  360 Wire.h（I2C/TWI介面通訊程式庫）
#--------------------------------------------------------------------------------

Wire.h	11-13
begin()，初始化連線	11-13
beginTransmission()，開始傳送	11-13
write()，傳遞資料	11-13
endTransmission()，結束傳送	11-13
onReceive()，設定接收資料	11-15
available()，確認有無資料	11-15
read()，讀取資料	11-15

#--------------------------------------------------------------------------------
# 373  WebServer.h（Webduino程式庫）
#--------------------------------------------------------------------------------

命令（command）	16-2, 16-4
setDefaultCommand()，設定預設命楞	16-5, 16-6
addCommand()，新增命令	16-5, 16-7
processConnection()，處理連線請求	16-6
readPostparam()，讀取POST資料	16-25
URLPARAM_RESULT，URL解析字串值	16-32
nextURLparam()，讀取URL參數	16-33
URLPARAM_EOS，URL參數結尾	16-33
#--------------------------------------------------------------------------------
#   
#--------------------------------------------------------------------------------



#--------------------------------------------------------------------------------
#   
#--------------------------------------------------------------------------------


#--------------------------------------------------------------------------------
#  
#--------------------------------------------------------------------------------

#--------------------------------------------------------------------------------
#   
#--------------------------------------------------------------------------------



#--------------------------------------------------------------------------------
#   
#--------------------------------------------------------------------------------


#--------------------------------------------------------------------------------
#  
#--------------------------------------------------------------------------------
