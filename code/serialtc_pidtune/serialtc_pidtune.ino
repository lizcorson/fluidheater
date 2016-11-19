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
#define MAXTEMP 40

const int serialFrequency = 1000; // 1 second
long lastMessageSent = 0;
//bool firstSend = false;
int heaterSetStatus = 0;
int heaterSetpoint = 20;
int heaterActive = 0;

//PID
//Define Variables we'll be connecting to
double Setpoint, Input, Output;
double Kp = 2;
double Ki = 2;
double Kd = 1;

//Specify the links and initial tuning parameters
PID myPID(&Input, &Output, &Setpoint,Kp,Ki,Kd, DIRECT);

void setup() {
  while (!Serial); // wait for Serial on Leonardo/Zero, etc
  Serial.begin(9600);
  //Serial.println("MAX31855 test");
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
     Serial.print("-1");
    } else {
     Serial.print(c);
     Input = c;
    }
    Serial.print(",");
    Serial.print(heaterActive);
    Serial.print(",");
    Serial.print(heaterSetStatus);
    Serial.print(",");
    Serial.print(heaterSetpoint);   
    Serial.print(",");
    Serial.print((int)(Output/2));
    Serial.print(",");
    Serial.print(Kp);
    Serial.print(","); 
    Serial.print(Ki);
    Serial.print(",");
    Serial.println(Kd);
    lastMessageSent = millis();
    // Message output format: temperature reading,heater on/off status, heater on/off set, temperature set point
    // Example: 36.5,0,1,35 
    // ^ Temperature reading is above set point so heater turns off
  }

  //manage heater
  if (heaterSetStatus == 1) {// && Input < (double)heaterSetpoint) {
    Setpoint = (double)heaterSetpoint;
    myPID.Compute();
    analogWrite(HEATERPIN,(int)(Output/2)); //need to limit to a max of 128.
    
    heaterActive = 1;
  } else {
    analogWrite(HEATERPIN,0);
    heaterActive = 0;
  }
  
  

}
void checkSerial() {
  String inputString;
  if(Serial.available() > 0) {
    inputString = Serial.readStringUntil('\n');
    //Serial.print("NEW INPUT: ");
    //Serial.println(inputString);
  
    //expected message format is 1,35,2,5,1
    // heater on/off, Tset, Kp, Ki, Kd
    //parse message -- this is gross but should work
    int delimIndex1 = inputString.indexOf(',');
    int delimIndex2 = inputString.indexOf(',',delimIndex1+1);
    int delimIndex3 = inputString.indexOf(',',delimIndex2+1);
    int delimIndex4 = inputString.indexOf(',',delimIndex3+1);
    String heaterString = inputString.substring(0,delimIndex1);
    String setpointString = inputString.substring(delimIndex1+1,delimIndex2);
    String KpString = inputString.substring(delimIndex2+1,delimIndex3);
    String KiString = inputString.substring(delimIndex3+1,delimIndex4);
    String KdString = inputString.substring(delimIndex4+1);

    //Serial.println("PID VALS:" + KpString + "," + KiString + "," + KdString);
    //need to change this parsing to allow for additional comma delimited values
    
    int newHeaterStatus = heaterString.toInt();
    int newSetpoint = setpointString.toInt();
    //sanity check data -- if it's okay, update global variables
    if (newHeaterStatus == 0 || newHeaterStatus == 1) {
      heaterSetStatus = newHeaterStatus;
      if (newSetpoint >= MINTEMP && newSetpoint <= MAXTEMP) {
        heaterSetpoint = newSetpoint;
      }
    }
    
    double newKp = KpString.toFloat();
    double newKi = KiString.toFloat();
    double newKd = KdString.toFloat();
    /*Serial.print("PID VALS:");
    Serial.print(newKp);
    Serial.print(",");
    Serial.print(newKi);
    Serial.print(",");
    Serial.println(newKd);*/
    myPID.SetTunings(newKp, newKi, newKd);
    Kp = newKp;
    Ki = newKi;
    Kd = newKd;
    /*Serial.print("PID VALS:");
    Serial.print(Kp);
    Serial.print(",");
    Serial.print(Ki);
    Serial.print(",");
    Serial.println(Kd);*/
    
    
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
