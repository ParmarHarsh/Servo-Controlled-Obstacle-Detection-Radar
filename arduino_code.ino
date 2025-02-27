// Includes the Servo library for controlling servo motors
#include <Servo.h>

// Includes the Wire and LCD libraries for I2C communication and LCD control
#include <Wire.h>
#include <LiquidCrystal_I2C.h>

// Initialize an LCD object with I2C address 0x27 for a 20x4 display
LiquidCrystal_I2C lcdDisplay(0x27, 20, 4);

// Define pin numbers for the LED and Buzzer
int statusLed = 4;
int alarmBuzzer = 5;

// Define pin numbers for the Ultrasonic Sensor
const int ultrasonicTrigPin = 9;  // Trigger pin for the ultrasonic sensor
const int ultrasonicEchoPin = 10; // Echo pin for the ultrasonic sensor

// Variables to hold the duration of the sound pulse and the calculated distance
long soundDuration;
int measuredDistance;

// Create a Servo object to control the servo motor
Servo baseServo;

/**
 * setup()
 * Initializes all peripherals, including LED, Buzzer, LCD, and Servo.
 * Configures the ultrasonic sensor pins and sets up serial communication.
 */
void setup() {
    // Set up LED and Buzzer as outputs
    pinMode(statusLed, OUTPUT);  
    pinMode(alarmBuzzer, OUTPUT);

    // Activate the buzzer briefly at startup
    tone(alarmBuzzer, 1000, 2000);

    // Initialize the LCD display
    lcdDisplay.init();
    lcdDisplay.backlight(); // Turn on the LCD backlight

    // Set up ultrasonic sensor pins
    pinMode(ultrasonicTrigPin, OUTPUT);
    pinMode(ultrasonicEchoPin, INPUT);

    // Start serial communication for debugging
    Serial.begin(9600);

    // Attach the servo motor to pin 8
    baseServo.attach(8);
}

/**
 * computeDistance()
 * Calculates the distance using the ultrasonic sensor by sending a sound pulse
 * and measuring the time taken for the echo to return.
 * 
 * @return Distance in centimeters
 */
int computeDistance() {
    digitalWrite(ultrasonicTrigPin, LOW); 
    delayMicroseconds(2);

    // Send a 10-microsecond pulse to the trigger pin
    digitalWrite(ultrasonicTrigPin, HIGH); 
    delayMicroseconds(10);
    digitalWrite(ultrasonicTrigPin, LOW);

    // Measure the duration of the echo pulse
    soundDuration = pulseIn(ultrasonicEchoPin, HIGH);

    // Calculate distance based on the duration of the pulse
    measuredDistance = soundDuration * 0.034 / 2;

    return measuredDistance;
}

/**
 * loop()
 * Continuously rotates the servo motor, calculates the distance from the ultrasonic sensor,
 * and updates the system state (LCD, LED, and Buzzer) based on the measured distance.
 */
void loop() {
    // Rotate the servo motor from 15 to 165 degrees
    for (int angle = 15; angle <= 165; angle++) {  
        delay(30);
        measuredDistance = computeDistance(); // Calculate the distance

        if (measuredDistance <= 19) {
            // If an object is detected within 19 cm, display a warning
            lcdDisplay.setCursor(2, 0);
            lcdDisplay.print("Base: Attacked!");
            digitalWrite(statusLed, HIGH); // Turn on the warning LED
            tone(alarmBuzzer, 440); // Activate the buzzer with a warning tone
            delay(2000); // Keep the warning active for 2 seconds
        } else {
            // If no object is detected, indicate the base is safe
            baseServo.write(angle); // Move the servo to the current angle
            lcdDisplay.setCursor(2, 0);
            lcdDisplay.print("Base: Safe...!");
            noTone(alarmBuzzer); // Turn off the buzzer
            digitalWrite(statusLed, LOW); // Turn off the warning LED
        }

        // Print debug information to the Serial Monitor
        Serial.print(angle); // Current servo angle
        Serial.print(",");
        Serial.print(measuredDistance); // Measured distance
        Serial.print(".");
    }

    // Rotate the servo motor back from 165 to 15 degrees
    for (int angle = 165; angle > 15; angle--) {  
        delay(30);
        measuredDistance = computeDistance(); // Calculate the distance

        if (measuredDistance <= 19) {
            // Display a warning if the base is under attack
            lcdDisplay.setCursor(2, 0);
            lcdDisplay.print("Base, Attacked!");
            digitalWrite(statusLed, HIGH);
            tone(alarmBuzzer, 440);
            delay(2000);
        } else {
            // Indicate that the base is safe
            baseServo.write(angle);
            lcdDisplay.setCursor(2, 0);
            lcdDisplay.print("Base, Safe...!");
            noTone(alarmBuzzer);
            digitalWrite(statusLed, LOW);
        }

        // Print debug information to the Serial Monitor
        Serial.print(angle);
        Serial.print(",");
        Serial.print(measuredDistance);
        Serial.print(".");
    }

    delay(300); // Small delay before restarting the loop
}