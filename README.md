# Servo-Controlled Obstacle Detection Radar

## Project Overview
The **Servo-Controlled Obstacle Detection Radar** is an innovative, cost-effective, and scalable solution for real-time obstacle detection. It utilizes an ultrasonic sensor mounted on a servo motor to scan the environment and measure the distance to nearby objects. The system provides feedback through various output devices, including an **LCD display**, **LED indicator**, and **buzzer**. In addition, the radar data is visualized in real-time using a **Processing-based graphical user interface**.

---

## Key Features:
- **Distance Measurement**: Uses an HC-SR04 ultrasonic sensor for accurate distance detection.
- **Servo Motor for Scanning**: The servo motor rotates the ultrasonic sensor to scan the environment in a 180° arc, enabling thorough scanning.
- **Real-time Feedback**: Alerts through an LCD display, buzzer, and LED when obstacles are detected.
- **Graphical Visualization**: The radar data is displayed through a Processing-based graphical user interface, providing a real-time radar sweep and detection visualization.

---

## Hardware Components:
- **Arduino MKR Vidor 4000**: Microcontroller for processing sensor data and controlling the system.
- **HC-SR04 Ultrasonic Sensor**: Used for measuring distances to obstacles.
- **Servo Motor**: Rotates the ultrasonic sensor for scanning.
- **I2C-based LCD Display**: Displays system status and feedback.
- **LED**: Visual indicator of object detection.
- **Buzzer**: Emits an alert sound when an obstacle is detected.
- **Breadboard and Jumper Wires**: For component connections.
- **Miscellaneous**: Resistors, USB cable for Arduino, crocodile clips for testing.

---

## Software Setup:

1. **Arduino Code**:
   - Open the `arduino_code.ino` file in the Arduino IDE.
   - Select the appropriate board (Arduino MKR Vidor 4000) and upload the code to the Arduino.

2. **Processing Code**:
   - Download and install the Processing IDE from [Softonic](https://processing.en.softonic.com/).
   - Open the `processing_software_code.pde` file in the Processing IDE.
   - Run the code to visualize the radar sweep and detected obstacles.

---

## Hardware Setup:

### 1. **Ultrasonic Sensor (HC-SR04)**:
   - VCC to 5V pin on Arduino.
   - GND to GND on Arduino.
   - TRIG to digital Pin 9.
   - ECHO to digital Pin 10.

### 2. **Servo Motor**:
   - Signal pin to digital Pin 8 on Arduino.
   - Power and Ground to breadboard connections.

### 3. **LCD Display (I2C)**:
   - SDA to A4 pin on Arduino.
   - SCL to A5 pin on Arduino.
   - VCC to 5V and GND to GND on Arduino.

### 4. **LED**:
   - Anode to digital Pin 4 (with a current-limiting resistor).
   - Cathode to GND.

### 5. **Buzzer**:
   - Positive terminal to digital Pin 5.
   - Negative terminal to GND.

---

## Running the System:

1. **Arduino Setup**:
   - Upload the `arduino_code.ino` to the Arduino MKR Vidor 4000.
   - The system will begin scanning with the ultrasonic sensor and rotating it with the servo motor.
   - The LCD display will show system status (e.g., "Base Safe" or "Base Attacked").
   - The LED and buzzer will activate when an obstacle is detected within the critical range (≤ 19 cm).

2. **Processing Visualization**:
   - Open the `processing_software_code.pde` file in the Processing IDE.
   - Run the code to view the radar's real-time sweep on the graphical interface.
   - Detected objects will appear as colored circles (green for safe, red for danger).

---

## Demonstration Video:
A demonstration video showcasing the system in action can be found in the file: [DEMONSTRATION_VIDEO.mov]. This video highlights how the radar system detects obstacles and provides feedback via visual and auditory signals.

