#define DEBUG // Please comment it if you are not debugging
// Compiled with: Arduino 1.8.13
// MightyCore 2.0.3
String HWtype = "SPACEDOS03";
String FWversion = "S04"; // 1 MHz internal oscillator / 250 kHz during integration 
#define MAXFILESIZE 28000000 // in bytes, 4 MB per day, 28 MB per week, 122 MB per month
#define MAXCOUNT 53000 // in measurement cycles, 7 479 per day, 52353 per week, 224 369 per month
#define MAXFILES 100 // maximal number of files on SD card
#define ZERO 256  // 5th channel is channel 1 (column 10 from 0, ussually DCoffset or DCoffset+1)

/*
  SPACEDOS03 derived from AIRDOS-F for USTSIPIN02A
 
6 month endurance with 5x LG 18650

ISP
---
PD0     RX
PD1     TX
RESET#  through 50M capacitor to RST#

SDcard
------
DAT3   SS   4 B4
CMD    MOSI 5 B5
DAT0   MISO 6 B6
CLK    SCK  7 B7

ANALOG
------
+      A0  PA0
-      A1  PA1
RESET  0   PB0

LED
---
LED_green  23  PC7      


                     Mighty 1284p    
                      +---\/---+
           (D 0) PB0 1|        |40 PA0 (AI 0 / D24)
           (D 1) PB1 2|        |39 PA1 (AI 1 / D25)
      INT2 (D 2) PB2 3|        |38 PA2 (AI 2 / D26)
       PWM (D 3) PB3 4|        |37 PA3 (AI 3 / D27)
    PWM/SS (D 4) PB4 5|        |36 PA4 (AI 4 / D28)
      MOSI (D 5) PB5 6|        |35 PA5 (AI 5 / D29)
  PWM/MISO (D 6) PB6 7|        |34 PA6 (AI 6 / D30)
   PWM/SCK (D 7) PB7 8|        |33 PA7 (AI 7 / D31)
                 RST 9|        |32 AREF
                VCC 10|        |31 GND
                GND 11|        |30 AVCC
              XTAL2 12|        |29 PC7 (D 23)
              XTAL1 13|        |28 PC6 (D 22)
      RX0 (D 8) PD0 14|        |27 PC5 (D 21) TDI
      TX0 (D 9) PD1 15|        |26 PC4 (D 20) TDO
RX1/INT0 (D 10) PD2 16|        |25 PC3 (D 19) TMS
TX1/INT1 (D 11) PD3 17|        |24 PC2 (D 18) TCK
     PWM (D 12) PD4 18|        |23 PC1 (D 17) SDA
     PWM (D 13) PD5 19|        |22 PC0 (D 16) SCL
     PWM (D 14) PD6 20|        |21 PD7 (D 15) PWM
                      +--------+
*/

#include <SD.h>         
#include "wiring_private.h"
#include <Wire.h>   

#define LED         23   // PC7
#define RESET       0    // PB0
#define SDpower1    1    // PB1
#define SDpower2    2    // PB2
#define SDpower3    3    // PB3
#define SS          4    // PB4
#define MOSI        5    // PB5
#define MISO        6    // PB6
#define SCK         7    // PB7
#define INT         20   // PC4
#define ANALOG_ON   15   // PD7
#define LED1        21   // PC5
#define LED2        22   // PC6
#define LED3        23   // PC7

#define CHANNELS 512 // number of channels in buffer for histogram, including negative numbers

String filename = "";
uint16_t fn;
uint16_t count = 0;
uint32_t serialhash = 0;
uint16_t base_offset = ZERO - 1;
uint8_t lo, hi;
uint16_t u_sensor;

// Read Analog Differential without gain (read datashet of ATMega1280 for refference)
// Use analogReadDiff(NUM)
//   NUM  | POS PIN             | NEG PIN           |   GAIN
//  0 | A0      | A1      | 1x
//  1 | A1      | A1      | 1x
//  2 | A2      | A1      | 1x
//  3 | A3      | A1      | 1x
//  4 | A4      | A1      | 1x
//  5 | A5      | A1      | 1x
//  6 | A6      | A1      | 1x
//  7 | A7      | A1      | 1x
//  8 | A8      | A9      | 1x
//  9 | A9      | A9      | 1x
//  10  | A10     | A9      | 1x
//  11  | A11     | A9      | 1x
//  12  | A12     | A9      | 1x
//  13  | A13     | A9      | 1x
//  14  | A14     | A9      | 1x
//  15  | A15     | A9      | 1x
#define PIN 0
uint8_t analog_reference = INTERNAL2V56; // DEFAULT, INTERNAL, INTERNAL1V1, INTERNAL2V56, or EXTERNAL
// the differential channels should not be used with an AREF < 2V

uint32_t tm;
uint8_t tm_s100;

uint8_t bcdToDec(uint8_t b)
{
  return ( ((b >> 4)*10) + (b%16) );
}

void readRTC()
{
  Wire.beginTransmission(0x51);
  Wire.write(0);
  Wire.endTransmission();
  
  Wire.requestFrom(0x51, 6);
  tm_s100 = bcdToDec(Wire.read());
  uint8_t tm_sec = bcdToDec(Wire.read() & 0x7f);
  uint8_t tm_min = bcdToDec(Wire.read() & 0x7f);
  tm = bcdToDec(Wire.read());
  tm += bcdToDec(Wire.read()) * 100;
  tm += bcdToDec(Wire.read()) * 10000;
  tm = tm * 60 * 60 + tm_min * 60 + tm_sec;
}

void(* resetFunc) (void) = 0; //declare reset function at address 0

void setup()
{
  // Open serial communications 
  Serial.begin(9600);
  Serial.println("#Cvak...");
  
  ADMUX = (analog_reference << 6) | ((PIN | 0x10) & 0x1F);
  
  ADCSRB = 0;               // Switching ADC to Free Running mode
  sbi(ADCSRA, ADATE);       // ADC autotrigger enable (mandatory for free running mode)
  sbi(ADCSRA, ADSC);        // ADC start the first conversions
  sbi(ADCSRA, 2);           // 0x100 = clock divided by 16, 62.5 kHz, 208 us for 13 cycles of one AD conversion, 24 us fo 1.5 cycle for sample-hold
  cbi(ADCSRA, 1);        
  cbi(ADCSRA, 0);        

  //pinMode(SDpower1, OUTPUT);  // SDcard interface
  //pinMode(SDpower2, OUTPUT);     
  //pinMode(SDpower3, OUTPUT);     
  //pinMode(SS, OUTPUT);     
  //pinMode(MOSI, INPUT);     
  //pinMode(MISO, INPUT);     
  //pinMode(SCK, OUTPUT);  

  DDRB = 0b10011110;
  PORTB = 0b00000000;  // SDcard Power OFF
  DDRA = 0b11111100;
  PORTA = 0b00000000;  
  DDRC = 0b11101100;
  PORTC = 0b00000000;  
  DDRD = 0b11111111;
  PORTD = 0b10000000;  
  
  //!!! Wire.setClock(100000);
  // Initiation of RTC
  Wire.beginTransmission(0x51); // init clock
  Wire.write((uint8_t)0x23); // Start register
  Wire.write((uint8_t)0x00); // 0x23
  Wire.write((uint8_t)0x00); // 0x24 Two's complement offset value
  Wire.write((uint8_t)0b00000101); // 0x25 Normal offset correction, disable low-jitter mode, set load caps to 6 pF
  Wire.write((uint8_t)0x00); // 0x26 Battery switch reg, same as after a reset
  Wire.write((uint8_t)0x00); // 0x27 Enable CLK pin, using bits set in reg 0x28
  Wire.write((uint8_t)0x97); // 0x28 stop watch mode, no periodic interrupts, CLK pin off
  Wire.write((uint8_t)0x00); // 0x29
  Wire.write((uint8_t)0x00); // 0x2a
  Wire.endTransmission();
  Wire.beginTransmission(0x51); // reset clock
  Wire.write(0x2f); 
  Wire.write(0x2c);
  Wire.endTransmission();
  Wire.beginTransmission(0x51); // start stop-watch
  Wire.write(0x28); 
  Wire.write(0x97);
  Wire.endTransmission();
  Wire.beginTransmission(0x51); // reset stop-watch
  Wire.write((uint8_t)0x00); // Start register
  Wire.write((uint8_t)0x00); // 0x00
  Wire.write((uint8_t)0x00); // 0x01 
  Wire.write((uint8_t)0x00); // 0x02 
  Wire.write((uint8_t)0x00); // 0x03
  Wire.write((uint8_t)0x00); // 0x04
  Wire.write((uint8_t)0x00); // 0x05
  Wire.endTransmission();
  
  for(int i=0; i<3; i++)  
  {
    delay(50);
    digitalWrite(LED, HIGH);  // Blink indicating inserting batteryes
    delay(10);
    digitalWrite(LED, LOW);  
  }

  {
    uint16_t DCoffset;
    for (uint8_t n=0; n<8; n++) 
    { 
      // measurement of ADC offset
      ADMUX = (analog_reference << 6) | 0b10001; // Select +A1,-A1 for offset correction
      delay(200);
      ADCSRB = 0;               // Switching ADC to Free Running mode
      sbi(ADCSRA, ADATE);       // ADC autotrigger enable (mandatory for free running mode)
      sbi(ADCSRA, ADSC);        // ADC start the first conversions
      sbi(ADCSRA, 2);           // 0x100 = clock divided by 16, 62.5 kHz, 208 us for 13 cycles of one AD conversion, 24 us fo 1.5 cycle for sample-hold
      cbi(ADCSRA, 1);
      cbi(ADCSRA, 0);
      sbi(ADCSRA, ADIF);                  // reset interrupt flag from ADC
      while (bit_is_clear(ADCSRA, ADIF)); // wait for the first conversion
      sbi(ADCSRA, ADIF);                  // reset interrupt flag from ADC
      lo = ADCL;
      hi = ADCH;
      ADMUX = (analog_reference << 6) | 0b10000; // Select +A0,-A1 for measurement
      ADCSRB = 0;               // Switching ADC to Free Running mode
      sbi(ADCSRA, ADATE);       // ADC autotrigger enable (mandatory for free running mode)
      sbi(ADCSRA, ADSC);        // ADC start the first conversions
      sbi(ADCSRA, 2);           // 0x100 = clock divided by 16, 62.5 kHz, 208 us for 13 cycles of one AD conversion, 24 us fo 1.5 cycle for sample-hold
      cbi(ADCSRA, 1);
      cbi(ADCSRA, 0);
      // combine the two bytes
      u_sensor = (hi << 7) | (lo >> 1);
      // manage negative values
      if (u_sensor <= (CHANNELS / 2) - 1 ) {
        u_sensor += (CHANNELS / 2);
      } else {
        u_sensor -= (CHANNELS / 2);
      }
      DCoffset += u_sensor;
    }
    base_offset = DCoffset >> 3; // Calculate mean of 8 measurements
  }
    
  Serial.println("#Hmmm...");

  // make a string for device identification output
  String dataString = "$DOS," + HWtype + "," + FWversion + "," + String(ZERO) + ","; // FW version and Git hash
  
  Wire.beginTransmission(0x58);                   // request SN from EEPROM
  Wire.write((int)0x08); // MSB
  Wire.write((int)0x00); // LSB
  Wire.endTransmission();
  Wire.requestFrom((uint8_t)0x58, (uint8_t)16);    
  for (int8_t reg=0; reg<16; reg++)
  { 
    uint8_t serialbyte = Wire.read(); // receive a byte
    if (serialbyte<0x10) dataString += "0";
    dataString += String(serialbyte,HEX);    
    serialhash += serialbyte;
  }

  {
    DDRB = 0b10111110;
    PORTB = 0b00001111;  // SDcard Power ON
  
    // make sure that the default chip select pin is set to output
    // see if the card is present and can be initialized:
    if (!SD.begin(SS)) 
    {
      Serial.println("#Card failed, or not present");
      // don't do anything more:
      return;
    }
    
    for (fn = 1; fn<MAXFILES; fn++) // find last file
    {
       filename = String(fn) + ".txt";
       if (SD.exists(filename) == 0) break;
    }
    fn--;
    filename = String(fn) + ".txt";
    
    // open the file. note that only one file can be open at a time,
    // so you have to close this one before opening another.
    File dataFile = SD.open(filename, FILE_WRITE);

    if (dataFile.size() > MAXFILESIZE)
    {
      dataFile.close();
      fn++;
      filename = String(fn) + ".txt";      
      dataFile = SD.open(filename, FILE_WRITE);
    }
  
    // if the file is available, write to it:
    if (dataFile) 
    {
      dataFile.println(dataString);  // write to SDcard (800 ms)     
      dataFile.close();
  
      Serial.println(dataString);  // print SN to terminal 
    }  
    // if the file isn't open, pop up an error:
    else 
    {
      Serial.println("#error opening datalog.txt");
    }
  
    DDRB = 0b10011110;
    PORTB = 0b00000001;  // SDcard Power OFF          
  }  
  disablePower(POWER_TIMER1);
  disablePower(POWER_TIMER2);
  disablePower(POWER_TIMER3);
#ifdef DEBUG
#else
  delay(100);
  Serial.end();
  disablePower(POWER_SERIAL0);
#endif
  disablePower(POWER_SERIAL1);
}

bool everithingOK = false;

void loop()
{
  uint16_t histogram[CHANNELS];  
  for(int n=0; n<CHANNELS; n++)
  {
    histogram[n]=0;
  }
  
  sbi(ADCSRA, ADIF);                  // reset interrupt flag from ADC
  DDRB = 0b10011111;                  // Reset peak detector
  delayMicroseconds(100);             // guaranteed reset
  DDRB = 0b10011110;                  // Peak detector to input

  uint16_t suppress = 0;      
  
#ifdef DEBUG
  readRTC();
  Serial.print("ADCstart ");
  Serial.print(tm); 
  Serial.print(".");
  Serial.println(tm_s100); 
  delay(100);
#endif
  
  cbi(ADCSRA, 2); // 0x010 = clock 250 kHz divided by 4, 62.5 kHz, 224 us for 14 cycles of one AD conversion
  sbi(ADCSRA, 1); // 4.5 kS/s, 24 us fo 1.5 cycle for sample-hold
//!!!!
  sbi(ADCSRA, 0); // successive approximation circuitry requires an input clock frequency between 50 kHz and 200 kHz
//  clock_prescale_set(clock_div_32); // CPU clock 250 kHz
  clock_prescale_set(clock_div_16); // CPU clock 250 kHz
  if (everithingOK)
  {
    digitalWrite(LED, HIGH);  // Blink on Lembit's demand
    delay(2);     
    digitalWrite(LED, LOW);  
    everithingOK = false;        
  }
  // dosimeter integration
  noInterrupts();
  uint8_t previous_pulse = 1; // ignore the first ADC
  for (uint16_t i=65535; i>0; i--)    // 14.67984 s
  {
    while (bit_is_clear(ADCSRA, ADIF)); // wait for end of conversion 
//DDRB = 0b10011111;                  // Reset peak detector
//DDRB = 0b10011110;
    uint8_t missed_pulse = PINB; // pulse peak before S/H?
    //delayMicroseconds();              // 24 us wait for 1.5 cycle of 62.5 kHz ADC clock for sample/hold for next conversion
    sbi(ADCSRA, ADIF);                  // reset ADC interrupt flag
    asm("NOP");                                    // cca 30 us after conversion
    asm("NOP");
    asm("NOP");
    asm("NOP");
    asm("NOP");
    asm("NOP");
    asm("NOP");
    
    DDRB = 0b10011111;                  // Reset peak detector
    asm("NOP");                         // cca 7 us is neaded for 2k2 resistor and 100n capacitor in peak detector
    asm("NOP"); // 4 us for one NOP with 250 kHz CPU clock
    asm("NOP");
    DDRB = 0b10011110;

    // we have to read ADCL first; doing so locks both ADCL
    // and ADCH until ADCH is read.  reading ADCL second would
    // cause the results of each conversion to be discarded,
    // as ADCL and ADCH would be locked when it completed.
    lo = ADCL;
    hi = ADCH;

    // combine the two bytes
    u_sensor = (hi << 7) | (lo >> 1);

    // manage negative values
    if (u_sensor <= (CHANNELS/2)-1 ) {u_sensor += (CHANNELS/2);} else {u_sensor -= (CHANNELS/2);}
            
    if (previous_pulse & 1) 
    {
      suppress++;
    }
    else
    {
      histogram[u_sensor]++;
    }

    histogram[u_sensor]++;
    previous_pulse = missed_pulse;
  }  
  clock_prescale_set(clock_div_8); // CPU clock 1 MHz
  interrupts();
   
  // Data out
  {
    readRTC();

    // make a string for assembling the data to log:
    String dataString = "";

    #define RANGE 250
    
    // make a string for assembling the data to log:
    dataString += "$HIST,";
    dataString += String(count); 
    dataString += ",";  
    dataString += String(tm); 
    dataString += ".";
    dataString += String(tm_s100); 
    dataString += ",";
    dataString += String(suppress);
    
    for(int n=base_offset-1; n<(base_offset-1+RANGE); n++)  
    {
      dataString += ",";
      dataString += String(histogram[n]); 
    }
    
    count++;

    {
      DDRB = 0b10111110;
      PORTB = 0b00001111;  // SDcard Power ON

#ifdef DEBUG
      readRTC();
      Serial.print("SDwrite ");
      Serial.print(tm); 
      Serial.print(".");
      Serial.println(tm_s100); 
#endif

      // make sure that the default chip select pin is set to output
      // see if the card is present and can be initialized:
      if (!SD.begin(SS)) 
      {
        //Serial.println("#Card failed, or not present");
        // don't do anything more:
        resetFunc();
      }

      // open the file. note that only one file can be open at a time,
      // so you have to close this one before opening another.
      File dataFile = SD.open(filename, FILE_WRITE);
    
      // if the file is available, write to it:
      if (dataFile) 
      {
        dataFile.println(dataString);  // write to SDcard (800 ms) 
        dataFile.close();
        everithingOK = true;
      }  
      else
      {
        resetFunc();
      }

#ifdef DEBUG
      readRTC();
      Serial.print("SDwrite ");
      Serial.print(tm); 
      Serial.print(".");
      Serial.println(tm_s100); 
#endif

      DDRB = 0b10011110;
      PORTB = 0b00000001;  // SDcard Power OFF

#ifdef DEBUG
      Serial.println(dataString);  // print to terminal (additional 700 ms in DEBUG mode)
      delay(100);
#endif

      if (count > MAXCOUNT) resetFunc(); //call reset 
    }          
  }    
}
