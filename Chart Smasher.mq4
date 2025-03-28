//+------------------------------------------------------------------+
//|                                                  ChartSmasher.mq4 |
//|                                         Copyright 2025, Godfather |
//|                              https://wa.me/message/4E7FBHOTLXAMF1 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Godfatherofnas100"
#property link      "https://wa.me/message/4E7FBHOTLXAMF1"
#property version   "1.00"
#property strict
#include<openordercheck.mqh>

input string MySymbol = NULL; // provide the symbol
input ENUM_TIMEFRAMES MyTimeFrame = PERIOD_CURRENT; // For per minute, hour or monthly
input int MyAvgPeriod = 50; // time frame for calculating moving average
input ENUM_APPLIED_PRICE MyPrice = PRICE_CLOSE; // what price do we want to consider
input double LotSize = 0.01; // the lot size we wish to trade
input int FirstBBand = 1;
input int SecondBBand = 2;
input int ThirdBBand = 6;
input int MacdFast = 24;
input int MacdSlow = 52;
input int MacdSignal = 18;
input string ContUpdate = "NO"; // Should TP & SL Keep Updating Continuously

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int MagicNumber = 9228+Period()+StringGetChar(MySymbol, 0)+StringGetChar(MySymbol, 3); //set the unique number for each comb of currency pair and timeframe
int OrderId;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

// Function to add the icon in the center of the chart

void DisplayBotName()
{
    string labelName = "BotNameLabel";  // Name of the label object

    // Create the label on the chart
    int labelHandle = ObjectCreate(0, labelName, OBJ_LABEL, 0, 0, 0);

    // Set label properties (position, text size, color, etc.)
    ObjectSetInteger(0, labelName, OBJPROP_XDISTANCE, 350);  // Horizontal position
    ObjectSetInteger(0, labelName, OBJPROP_YDISTANCE, 450);  // Vertical position (adjust for bottom placement)
    ObjectSetInteger(0, labelName, OBJPROP_XSIZE, 300);  // Label width (adjust as needed)
    ObjectSetInteger(0, labelName, OBJPROP_YSIZE, 250);   // Label height (adjust as needed)
    
    // Set the text for the label
    ObjectSetString(0, labelName, OBJPROP_TEXT, "The Chart Smasher");

    // Set the text color to a red and blue gradient effect (combination)
    ObjectSetInteger(0, labelName, OBJPROP_COLOR, clrBlue);  // Set the color (Red)

    // Set the font properties (size)
    ObjectSetInteger(0, labelName, OBJPROP_FONTSIZE, 50);  // Font size

    // Apply a bold font by using a common bold font
    ObjectSetString(0, labelName, OBJPROP_FONT, "Arial Bold");  // Use a bold font

    // To simulate shadow effect, create a duplicate label with a slight offset
    string shadowLabelName = "ShadowLabel";
    ObjectCreate(0, shadowLabelName, OBJ_LABEL, 0, 0, 0);
    ObjectSetInteger(0, shadowLabelName, OBJPROP_XDISTANCE, 351);  // Slight horizontal offset
    ObjectSetInteger(0, shadowLabelName, OBJPROP_YDISTANCE, 451);  // Slight vertical offset
    ObjectSetString(0, shadowLabelName, OBJPROP_TEXT, "The Chart Smasher");
    ObjectSetInteger(0, shadowLabelName, OBJPROP_COLOR, clrRed);  // Shadow color (black)
    ObjectSetInteger(0, shadowLabelName, OBJPROP_FONTSIZE, 51);  // Font size for shadow
    ObjectSetString(0, shadowLabelName, OBJPROP_FONT, "Arial Bold");  // Bold font for shadow
    


    // Redraw the chart to apply changes
    ChartRedraw();
}
void DisplayCreatorName()
{
    string creatorLabelName = "CreatorLabel";  // Name of the label object for the creator's name

    // Create the label for the creator's name
    ObjectCreate(0, creatorLabelName, OBJ_LABEL, 0, 0, 0);

    // Set label properties (position, text size, color, etc.)
    ObjectSetInteger(0, creatorLabelName, OBJPROP_XDISTANCE, 367);  // Horizontal position
    ObjectSetInteger(0, creatorLabelName, OBJPROP_YDISTANCE, 505);  // Vertical position (adjust for bottom placement)
    ObjectSetInteger(0, creatorLabelName, OBJPROP_XSIZE, 400);  // Label width (adjust as needed)
    ObjectSetInteger(0, creatorLabelName, OBJPROP_YSIZE, 50);   // Label height (adjust as needed)
    
    // Set the text for the label (Creator's name)
    ObjectSetString(0, creatorLabelName, OBJPROP_TEXT, " By Godfatherofnas100");

    // Set the text color (can use blue, red, or other combination)
    ObjectSetInteger(0, creatorLabelName, OBJPROP_COLOR, clrBlue);  // Set the color to blue

    // Set the font properties (signature-like font)
    ObjectSetInteger(0, creatorLabelName, OBJPROP_FONTSIZE, 26);  // Font size
    ObjectSetString(0, creatorLabelName, OBJPROP_FONT, "Brush Script");  // Signature-like font (choose appropriate font)

    // Redraw the chart to apply changes
    ChartRedraw();
}

// Function to add the icon in the center of the chart
void AddBotIcon()
{
    // Specify the file path to your PNG image file (with transparency)
    string iconFilePath = "t.BMP";  // Replace with actual PNG file path

    // Create the icon on the chart
    int iconHandle = ObjectCreate(0, "BotIcon", OBJ_BITMAP, 0, 0, 0);
    
    // Set size of the icon (adjust to fit your desired size)
    ObjectSetInteger(0, "BotIcon", OBJPROP_XSIZE, 500); // Set width of the icon
    ObjectSetInteger(0, "BotIcon", OBJPROP_YSIZE, 500); // Set height of the icon
    
    // Get chart width and height
    int chartWidth = ChartGetInteger(0, CHART_WIDTH_IN_BARS); // Get chart width
    int chartHeight = ChartGetInteger(0, CHART_HEIGHT_IN_PIXELS); // Get chart height
    
    // Calculate the position for the icon to be in the center of the chart
    int centerX = (chartWidth / 2) - (ObjectGetInteger(1, "BotIcon", OBJPROP_XSIZE) / 2); // Center the image horizontally
    int centerY = (chartHeight / 2) - (ObjectGetInteger(1, "BotIcon", OBJPROP_YSIZE) / 2); // Center the image vertically

    // Position the icon at the center
    ObjectSetInteger(0, "BotIcon", OBJPROP_XDISTANCE, centerX); // Set horizontal position
    ObjectSetInteger(0, "BotIcon", OBJPROP_YDISTANCE, centerY); // Set vertical position
    
    // Set the file path for the PNG image (with transparency)
    ObjectSetString(0, "BotIcon", OBJPROP_BMPFILE, iconFilePath);

    // Place the object behind other chart objects by setting the Z-order to a low value
    ObjectSetInteger(0, "BotIcon", OBJPROP_ZORDER, 0); // Set Z-order to place the image behind other objects
    
    // Redraw the chart to apply the changes
    ChartRedraw();
}


// Function to remove grid and set custom candle colors
void CustomizeChart()
{
    ChartSetInteger(0, CHART_SHOW_GRID, false);
    ChartSetInteger(0, CHART_COLOR_CANDLE_BULL, clrBlue); // Bullish candles = Blue
    ChartSetInteger(0, CHART_COLOR_CANDLE_BEAR, clrRed); // Bearish candles = Gray
    ChartSetInteger(0, CHART_COLOR_CHART_DOWN, clrRed); // Bullish candles = Blue
    ChartSetInteger(0, CHART_COLOR_CHART_UP, clrBlue); 
}
int OnInit()
{


   // Set grid visibility to false (if you don't want grid lines on the chart)
   ChartSetInteger(0, CHART_SHOW_GRID, 0);

   // Set the background color to black (optional)
   ChartSetInteger(0, CHART_COLOR_BACKGROUND, Black);

   // Set the background color to black (optional)
   ChartSetInteger(0, CHART_COLOR_BACKGROUND, Black);
    CustomizeChart();
    AddBotIcon();
    DisplayBotName();
    DisplayCreatorName();

//---
   Alert("You Have Just Awakened The Chart Smasher");
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   Alert("ChartSmasher Is Going Into Hybernation");
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---

// first band is at 1 std
   double UBBAND1 = iBands(MySymbol, MyTimeFrame, MyAvgPeriod, FirstBBand, 0, MyPrice, MODE_UPPER, 0);
   double LBBAND1 = iBands(MySymbol, MyTimeFrame, MyAvgPeriod, FirstBBand, 0, MyPrice, MODE_LOWER, 0);

// second band is at 2 std
   double UBBAND2 = iBands(MySymbol, MyTimeFrame, MyAvgPeriod, SecondBBand, 0, MyPrice, MODE_UPPER, 0);
   double LBBAND2 = iBands(MySymbol, MyTimeFrame, MyAvgPeriod, SecondBBand, 0, MyPrice, MODE_LOWER, 0);
   double MBBAND = iBands(MySymbol, MyTimeFrame, MyAvgPeriod, SecondBBand, 0, MyPrice, MODE_MAIN, 0);

// third band is at 6 std
   double UBBAND6 = iBands(MySymbol, MyTimeFrame, MyAvgPeriod, ThirdBBand, 0, MyPrice, MODE_UPPER, 0);
   double LBBAND6 = iBands(MySymbol, MyTimeFrame, MyAvgPeriod, ThirdBBand, 0, MyPrice, MODE_LOWER, 0);

// macd histogram value for confirmation
   double MACDMAIN = iMACD(MySymbol, MyTimeFrame, MacdFast, MacdSlow, MacdSignal, MyPrice, MODE_MAIN, 0);
   double MACDSIGNAL = iMACD(MySymbol, MyTimeFrame, MacdFast, MacdSlow, MacdSignal, MyPrice, MODE_SIGNAL, 0);

// if there is no order only then a new order would be sent
   if(!CheckOpenOrder(MagicNumber))
     {
      if(Ask >= LBBAND2 && Ask < UBBAND1 && MACDMAIN > MACDSIGNAL) //if price is between lower band 2 and upper band 1 and macd line above macd signal go long
        {

         Alert("Buy Now at "+ NormalizeDouble(Ask, Digits));
         Alert("Take Proft at "+ NormalizeDouble(UBBAND1, Digits));
         Alert("Stop Loss at "+ NormalizeDouble(LBBAND6, Digits));
         OrderId = OrderSend(MySymbol, OP_BUYLIMIT, LotSize, Ask, 10, NormalizeDouble(LBBAND6, Digits), NormalizeDouble(UBBAND1, Digits), "The Chart Smasher", MagicNumber);
         if(OrderId < 0)
            Alert("The Order Could Not Be Sent, ErrorCode: " + GetLastError());
        }
      else
         if(Bid <= UBBAND2 && Bid > LBBAND1 && MACDMAIN < MACDSIGNAL) //if price is between upper band 2 and lower band 1 and macd below signal go short
           {
            Alert("Sell Now at "+ NormalizeDouble(Bid, Digits));
            Alert("Take Proft at "+ NormalizeDouble(LBBAND1, Digits));
            Alert("Stop Loss at "+ NormalizeDouble(UBBAND6, Digits));
            OrderId = OrderSend(MySymbol, OP_SELLLIMIT, LotSize, Bid, 10, NormalizeDouble(UBBAND6, Digits), NormalizeDouble(LBBAND1, Digits),"The Chart Smasher", MagicNumber);
            if(OrderId < 0)
               Alert("The Order Could Not Be Sent, ErrorCode: " + GetLastError());
           }
      /*else
        {
         Alert("Hold Your Nerve");
        }*/
     }
   else // if an order has already been placed
     {
      if(ContUpdate=="Yes")
        {
         if(OrderSelect(OrderId, SELECT_BY_TICKET)==true) // check if extracting data is possible
           {
            int orderType = OrderType(); // check the ordertype, 0 = long, 1 = short
            double UpdatedTakeProfit;
            if(orderType == 0)
              {
               UpdatedTakeProfit = NormalizeDouble(UBBAND1, Digits); // modify the take profit for long position
              }
            else
              {
               UpdatedTakeProfit = NormalizeDouble(LBBAND1, Digits); // modify the take profit for short position
              }
            double TP = OrderTakeProfit();
            double OpenPrice = OrderOpenPrice();
            double TPdistance = MathAbs(TP - UpdatedTakeProfit);
            if((orderType ==0 && TP!=UpdatedTakeProfit && UpdatedTakeProfit > OpenPrice && TPdistance >= .0001) || (orderType ==1 && TP!=UpdatedTakeProfit && UpdatedTakeProfit < OpenPrice && TPdistance >= .0001)) // if the currect take profit is not equal to the updated take profit by at least a pip
              {
               bool ModifySuccess = OrderModify(OrderId, OrderOpenPrice(), OrderStopLoss(), UpdatedTakeProfit, 0);
               if(ModifySuccess == true)
                 {
                  Print("Order modified: ",OrderId);
                 }
               else
                 {
                  Print("Unable to modify order: ",OrderId);
                 }
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
