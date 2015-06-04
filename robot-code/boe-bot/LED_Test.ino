void setup()                                 // Built-in initialization block
{
  pinMode(13, OUTPUT);                       // Set digital pin 13 -> output
}  
 
void loop()                                  // Main loop auto-repeats
{                                         
  digitalWrite(13, HIGH);                    // Pin 13 = 5 V, LED emits light
} 
