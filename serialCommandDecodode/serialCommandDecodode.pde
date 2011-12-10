#include "WProgram.h"
#include <docSelCmd.h>


SerialCommands scmd;  //Create an instance of SerialCommands class
//scmd.cmdDecode();



void setup()
{
 Serial.begin(9600); //This is necessary to enable printing within loop()
 
}

void loop()
{
  scmd.cmdDecode();
  delay(3000);
  scmd.dispCmdBuffer();
}
