
void loopALL()
{
  for(i=20; i!=0; i--)
  {
    digitalWrite(pump1, HIGH);   // sets the LED on
    delay(5);                  // waits for a second
    digitalWrite(pump1, LOW);    // sets the LED off
    delay(5);                  // waits for a second
  }
  delay(5000);
  
  for(i=50; i!=0; i--)
  {
    digitalWrite(pump1, HIGH);   // sets the LED on
    delay(5);                  // waits for a second
    digitalWrite(pump1, LOW);    // sets the LED off
    delay(5);                  // waits for a second
  }
 
  delay(5000);
  
  for(i=20; i!=0; i--)
  {
    digitalWrite(pump1, HIGH);   // sets the LED on
    delay(5);                  // waits for a second
    digitalWrite(pump1, LOW);    // sets the LED off
    delay(5);                  // waits for a second
  } 
  
}
  

