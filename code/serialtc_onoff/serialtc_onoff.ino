#include <SPI.h>
#include <PID_v1.h>
#include "Adafruit_MAX31855.h"

// Connect to thermocouple instance with software SPI on any three
// digital IO pins.
#define MAXDO   5
#define MAXCS   6
#define MAXCLK  9

// initialize the Thermocouple
Adafruit_MAX31855 thermocouple(MAXCLK, MAXCS, MAXDO);

//heater control pin
#define HEATERPIN 11
#define MINTEMP 20
#define MAXTEMP 37

const int serialFrequency = 1000; // 1 second
long lastMessageSent = 0;
//bool firstSend = false;
int heaterSetStatus = 0;
int heaterSetpoint = 20;

//PID
//Define Variables we'll be connecting to
double Setpoint, Input, Output;

//Specify the links and initial tuning parameters
PID myPID(&Input, &Output, &Setpoint,2,5,1, DIRECT);

void setup() {
  while (!Serial); // wait for Serial on Leonardo/Zero, etc
  Serial.begin(9600);
  //Serial.println("MAX31855 test");
  // wait for MAX chip to stabilize
  delay(500); 
  pinMode(HEATERPIN, OUTPUT);
}

void loop() {
  checkSerial();
  //Send a serial message only once every serialFrequency ms
  if ((unsigned long)(millis() - lastMessageSent) > serialFrequency) {
    double c = thermocouple.readCelsius();
    if (isnan(c)) {
     Serial.print("-1");
    } else {
     Serial.print(c);
     Input = c;
    }
    Serial.print(",");
    Serial.print(heaterSetStatus);
    Serial.print(",");
    Serial.println(heaterSetpoint);   
    lastMessageSent = millis();
  }

  //manage heater
  if (heaterSetStatus == 1 && Input < (double)heaterSetpoint) {
    Setpoint = (double)heaterSetpoint;
    //myPID.Compute();
    //analogWrite(HEATERPIN,Output);
    analogWrite(HEATERPIN,60); //this number needs to be changed to get to higher temperatures
  } else {
    analogWrite(HEATERPIN,0);
  }
  
  

}
void checkSerial() {
  String inputString;
  if(Serial.available() > 0) {
    inputString = Serial.readStringUntil('\n');
    //Serial.print("NEW INPUT: ");
    //Serial.println(inputString);
  
    //expected message format is 1,35
    //parse message 
    int delimIndex = inputString.indexOf(',');
    String heaterString = inputString.substring(0,delimIndex);
    String setpointString = inputString.substring(delimIndex+1);
  
    int newHeaterStatus = heaterString.toInt();
    int newSetpoint = setpointString.toInt();
    //sanity check data -- if it's okay, update global variables
    if (newHeaterStatus == 0 || newHeaterStatus == 1) {
      heaterSetStatus = newHeaterStatus;
      if (newSetpoint >= MINTEMP && newSetpoint <= MAXTEMP) {
        heaterSetpoint = newSetpoint;
      }
    }
  } 
}

// Based on examples as below
/*************************************************** 
  This is an example for the Adafruit Thermocouple Sensor w/MAX31855K

  Designed specifically to work with the Adafruit Thermocouple Sensor
  ----> https://www.adafruit.com/products/269

  These displays use SPI to communicate, 3 pins are required to  
  interface
  Adafruit invests time and resources providing this open source code, 
  please support Adafruit and open-source hardware by purchasing 
  products from Adafruit!

  Written by Limor Fried/Ladyada for Adafruit Industries.  
  BSD license, all text above must be included in any redistribution
 ****************************************************/
