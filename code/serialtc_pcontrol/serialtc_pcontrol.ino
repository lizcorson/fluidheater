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
int heaterActive = 0;
int pwmOut = 0;

//PID
//Define Variables we'll be connecting to
double Setpoint, Input, Output;
double Kp = 200;
double Ki = 0;
double Kd = 0;
//Specify the links and initial tuning parameters
PID myPID(&Input, &Output, &Setpoint,Kp,Ki,Kd, DIRECT);

void setup() {
  while (!Serial1); // wait for Serial on Leonardo/Zero, etc
  Serial1.begin(9600);
  //Serial1.println("MAX31855 test");
  // wait for MAX chip to stabilize
  delay(500); 
  pinMode(HEATERPIN, OUTPUT);
  //turn the PID on
  myPID.SetMode(AUTOMATIC);  
}

void loop() {
  checkSerial();
  //Send a serial message only once every serialFrequency ms
  if ((unsigned long)(millis() - lastMessageSent) > serialFrequency) {
    double c = thermocouple.readCelsius();
    if (isnan(c)) {
     Serial1.print("-1");
    } else {
     Serial1.print(c);
     Input = c;
    }
    Serial1.print(",");
    Serial1.print(heaterActive);
    Serial1.print(",");
    Serial1.print(heaterSetStatus);
    Serial1.print(",");
    Serial1.print(heaterSetpoint);   
    Serial1.print(",");
    Serial1.println(pwmOut);
    lastMessageSent = millis();
    // Message output format: temperature reading,heater on/off status, heater on/off set, temperature set point,PWM output
    // Example: 36.5,1,1,35,81 
  }

  //manage heater
  if (heaterSetStatus == 1) { // if heater is active, output PWM based on PID
    Setpoint = (double)heaterSetpoint;
    myPID.Compute();
    pwmOut = (int)(Output/2);
    analogWrite(HEATERPIN,pwmOut); //need to limit to a max of 128.
    //heater is only active if PWM > 0
    if (pwmOut > 0) {
      heaterActive = 1;
    } else {
      heaterActive = 0;
    }
  } else { // if heater is not active, output 0 on heater pin
    pwmOut = 0;
    analogWrite(HEATERPIN,pwmOut);
    heaterActive = 0;
  }
}

void checkSerial() {
  String inputString;
  if(Serial1.available() > 0) {
    inputString = Serial1.readStringUntil('\n');
    //expected message format is 1,35
    //on/off,temp set point (C)
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
