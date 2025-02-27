import processing.serial.*; // Serial library for communication
Serial serialPort;          // Serial object for communication

// Variables to store the angle and distance
String currentAngleString = "";   
String currentDistanceString = "";  
int currentAngle, currentDistance;  // Integer variables for angle and distance
int radarStatus = 0;  // 0 = Safe, 1 = Danger (Attacked)
int previousRadarStatus = 0;  // To track the previous radar status for comparison

// Constants for radar visualization
int radarMaxRange = 200;  // Maximum radar range (20 cm converted to pixels)
int radarCenterX, radarCenterY;  // Radar's center position on the screen
int servoSweepStart = 15;  // Servo sweep start angle (in degrees)
int servoSweepEnd = 165;   // Servo sweep end angle (in degrees)

// Constants for color coding
int safeZoneColor = color(0, 255, 0);     // Green color for Safe zone
int dangerZoneColor = color(255, 0, 0);  // Red color for Danger zone
int radarGridColor = color(255, 100);    // Light white for radar grid lines

void setup() {
  size(600, 600);  // Set the window size
  radarCenterX = width / 2;  // Calculate radar center X
  radarCenterY = height / 2; // Calculate radar center Y
  
  background(0);  // Set the background color to black
  
  // Initialize serial communication (replace with your port)
  serialPort = new Serial(this, "/dev/tty.usbmodem101", 9600);
  serialPort.bufferUntil('.');  // Read data until '.' character
}

void draw() {
  // Clear the screen and redraw the radar
  background(0);
  drawRadarGrid();
  
  // Draw servo sweep line and detected object blips
  drawRadarSweep();
  drawDetectedObjects();
  
  // Display radar status and angle/distance information
  displayRadarStatus();
  if (currentDistance <= 20) {  // Display only when an object is detected within 20 cm
    displayAngleAndDistance();
  }
}

// Function to read the serial data from Arduino
void serialEvent(Serial serialPort) {
  String serialData = serialPort.readStringUntil('.');  // Read data until '.' character
  
  if (serialData != null) {
    // Remove any extra spaces or newline characters
    serialData = trim(serialData);
    
    // Split the data into angle and distance parts
    String[] dataParts = split(serialData, ',');
    if (dataParts.length == 2) {
      currentAngleString = dataParts[0];  // Angle part
      currentDistanceString = dataParts[1];  // Distance part
      
      // Convert string data to integers
      currentAngle = int(currentAngleString);
      currentDistance = int(currentDistanceString);
      
      // Update radar status based on the distance
      radarStatus = (currentDistance <= 19) ? 1 : 0;  // Danger if distance <= 19 cm
    }
  }
}

// Function to draw the radar grid (background circles and angle lines)
void drawRadarGrid() {
  noFill();
  stroke(radarGridColor);  // Light white color for grid
  
  // Draw concentric circles to represent distance intervals (5 cm each)
  for (int i = 5; i <= 20; i += 5) {
    float radius = map(i, 0, 20, 0, radarMaxRange);  // Map distance to radar's radius
    ellipse(radarCenterX, radarCenterY, radius * 2, radius * 2);
  }
  
  // Draw angle lines every 30°
  for (int angle = servoSweepStart; angle <= servoSweepEnd; angle += 30) {
    float xEnd = radarCenterX + radarMaxRange * cos(radians(angle));
    float yEnd = radarCenterY + radarMaxRange * sin(radians(angle));
    line(radarCenterX, radarCenterY, xEnd, yEnd);  // Draw the angle line
  }
}

// Function to draw the servo sweep line (rotating line)
void drawRadarSweep() {
  stroke(255, 255, 0);  // Yellow color for sweep line
  
  // Calculate the end point of the sweep line
  float sweepX = radarCenterX + radarMaxRange * cos(radians(currentAngle));
  float sweepY = radarCenterY + radarMaxRange * sin(radians(currentAngle));
  line(radarCenterX, radarCenterY, sweepX, sweepY);  // Draw the sweep line
}

// Function to draw detected objects (blips)
void drawDetectedObjects() {
  // Map the detected distance to the radar's radius
  float objectDistance = map(currentDistance, 0, 20, 0, radarMaxRange);
  
  // Calculate the object's position based on the angle and distance
  float objectX = radarCenterX + objectDistance * cos(radians(currentAngle));
  float objectY = radarCenterY + objectDistance * sin(radians(currentAngle));
  
  // Set color based on radar status
  fill(radarStatus == 1 ? dangerZoneColor : safeZoneColor);
  noStroke();
  ellipse(objectX, objectY, 10, 10);  // Draw the object as a circle
}

// Function to display the radar status (Safe or Danger)
void displayRadarStatus() {
  fill(255);  // White text color
  textSize(24);
  textAlign(CENTER, CENTER);
  
  // Display status message
  if (radarStatus == 0) {
    fill(safeZoneColor);  // Green for Safe
    text("Base: Safe", width / 2, height - 40);
  } else {
    fill(dangerZoneColor);  // Red for Danger
    text("Base: Attacked", width / 2, height - 40);
  }
}

// Function to display angle and distance information
void displayAngleAndDistance() {
  fill(255);  // White text color
  textSize(18);
  textAlign(CENTER, TOP);
  
  // Display the current angle and distance
  text("Angle: " + currentAngle + "°", width / 2, 20);
  text("Distance: " + currentDistance + " cm", width / 2, 40);
}
