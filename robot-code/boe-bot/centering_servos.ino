#include <Servo.h>                           // Include servo library

Servo servoLeft;                            // Declare left servo 
Servo servoRight;                            // Declare right servo

void setup()                                 // Built-in initialization block
{
  servoLeft.attach(13);                     // Attach left signal to pin 13
  servoLeft.writeMicroseconds(1500);        // 1.5 ms stay still signal
  
  
  servoRight.attach(12);                     // Attach right signal to pin 12
  servoRight.writeMicroseconds(1500);        // 1.5 ms stay still signal
}  
 
void loop()                                  // Main loop auto-repeats
{                                            // Empty, nothing needs repeating
}
