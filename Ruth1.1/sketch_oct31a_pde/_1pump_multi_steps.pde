
int pump1 = 10;                 // LED connected to digital pin 10
int ledPin2 = 11;                 // LED connected to digital pin 11
int ledPin3 = 12;                 // LED connected to digital pin 12
int ledPin4 = 13;                 // LED connected to digital pin 13
int i;
void setup()
{
  pinMode(pump1, OUTPUT);      // sets the digital pin as output
//  pinMode(ledPin2, OUTPUT);      // sets the digital pin as output
//  pinMode(ledPin3, OUTPUT);      // sets the digital pin as output
//  pinMode(ledPin4, OUTPUT);      // sets the digital pin as output
}
void loop()
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
  
//  for(i=440; i!=0; i--)
//  {
//    digitalWrite(ledPin2, HIGH);   // sets the LED on
//    delay(10);                  // waits for a second
//    digitalWrite(ledPin2, LOW);    // sets the LED off
//    delay(10);                  // waits for a second
//  }  
//  delay(250000);
//  for(i=100; i!=0; i--)
//  {
//    digitalWrite(ledPin3, HIGH);   // sets the LED on
//    delay(10);                  // waits for a second
//    digitalWrite(ledPin3, LOW);    // sets the LED off
//    delay(10);                  // waits for a second
//  }  
//  delay(120000);
//  for(i=180; i!=0; i--)
//  {
//    digitalWrite(ledPin4, HIGH);   // sets the LED on
//    delay(10);                  // waits for a second
//    digitalWrite(ledPin4, LOW);    // sets the LED off
//    delay(10);                  // waits for a second
//  }  
//  delay(120000);
//}




