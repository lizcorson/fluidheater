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

const int tempCheckDelay = 1000; // 1 second
long lastTCheck = 0;
//bool firstSend = false;
int heaterSetStatus = 0;
double heaterSetpoint = 20;
int heaterActive = 0;
int pwmOut = 0;
double tcRead = 0;

//PID
//Define Variables we'll be connecting to
double Setpoint, Input, Output;
double Kp = 175;
double Ki = 0;
double Kd = 0;
//Specify the links and initial tuning parameters
PID myPID(&Input, &Output, &Setpoint,Kp,Ki,Kd, DIRECT);

void setup() {
  Serial1.begin(38400);
  pinMode(HEATERPIN, OUTPUT);
  //turn the PID on
  myPID.SetMode(AUTOMATIC);  
}

void loop() {
  checkSerial();
  //Check temperature every tempCheckDelay ms
  if ((unsigned long)(millis() - lastTCheck) > tempCheckDelay) {
    double c = thermocouple.readCelsius();
    if (isnan(c)) {
     tcRead = -1; // so you know if there's a thermocouple error
    } else {
     Input = c;
     tcRead = c;
    }    
    lastTCheck = millis();
  }

  //manage heater
  if (heaterSetStatus == 1) { // if heater is active, output PWM based on PID
    Setpoint = (double)heaterSetpoint;
    myPID.Compute();
    pwmOut = (int)Output;
    analogWrite(HEATERPIN,pwmOut);
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
    //parse message -- need some kind of error checking
    int delimIndex = inputString.indexOf(',');
    if (delimIndex >= 1) {
      String heaterString = inputString.substring(0,delimIndex);
      String setpointString = inputString.substring(delimIndex+1);
    
      int newHeaterStatus = heaterString.toInt();
      double newSetpoint = setpointString.toFloat();
      //Serial.println(newHeaterStatus);
      //sanity check data -- if it's okay, update global variables
      if (newHeaterStatus == 0 || newHeaterStatus == 1) {
        heaterSetStatus = newHeaterStatus;
        if (newSetpoint >= MINTEMP && newSetpoint <= MAXTEMP) {
          heaterSetpoint = newSetpoint;
        }
      }
    }
    else if (inputString.indexOf("POLL") >= 0) {
      //do nothing for now, just don't return
    }
    else {
      return; //return if invalid request
    }
    Serial1.println((String)tcRead + "," + (String)heaterActive + "," + (String)heaterSetStatus + "," + (String)heaterSetpoint + "," + (String)pwmOut);
    // Message output format: temperature reading,heater on/off status, heater on/off set, temperature set point,PWM output
    // Example: 36.5,1,1,35,81 
  } 
}

//Credit to Adafruit for MAX31855K examples!
