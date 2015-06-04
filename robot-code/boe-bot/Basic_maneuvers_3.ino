#include <Servo.h>                           // Include servo library

Servo servoLeft;                             // Declare left and right servos
Servo servoRight;
 
void setup()                                 // Built-in initialization block
{
  servoLeft.attach(13);                      // Attach left signal to pin 13
  servoRight.attach(12);                     // Attach right signal to pin 12

  forward(2000);
  turnLeft(600);
  turnRight(600);
  backward(2000);

  servoLeft.detach();                        // Stop sending servo signals
  servoRight.detach();
}  

void loop()                                  // Main loop auto-repeats
{                                            // Empty, nothing needs repeating
}

void forward(int msTime)
{
  servoLeft.writeMicroseconds(1700);         // Left wheel counterclockwise
  servoRight.writeMicroseconds(1300);        // Right wheel clockwise
  delay(msTime);  
}

void backward(int msTime)
{
  servoLeft.writeMicroseconds(1300);         // Left wheel clockwise
  servoRight.writeMicroseconds(1700);        // Right wheel counterclockwise
  delay(msTime);   
}

void turnLeft(int msTime)
{
  servoLeft.writeMicroseconds(1300);         // Left wheel clockwise
  servoRight.writeMicroseconds(1300);        // Right wheel clockwise
  delay(msTime);   
}

void turnRight(int msTime)
{
  servoLeft.writeMicroseconds(1700);         // Left wheel counterclockwise
  servoRight.writeMicroseconds(1700);        // Right wheel counterclockwise
  delay(msTime); 
}


