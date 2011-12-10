// Arduino DOC Serial Command Library (docSelCmd)

// This is the interface for receiving serial commands and process them
// 
#include "WProgram.h"
#include "docSelCmd.h"

//constructor
SerialCommands::SerialCommands()
{
  _serialPortSpeed = 9600;			//Initial default speed is 9600
  _commandBufferSize = 5;   		//Initial default command buffer size is 5
 Serial.begin(_serialPortSpeed);	//Start serial port
 Serial.println("Constructor");
}


void SerialCommands::cmdDecode()
{
if (Serial.available() >= _commandBufferSize ) // wait for _commanddBufferSize characters
   {  
	for(int i=0; i < _commandBufferSize; i++)
	   commandBuffer[i] = Serial.read();
   }  
Serial.println("cmdDecode");
}

void SerialCommands::dispCmdBuffer()
{
	for(int i=0; i < _commandBufferSize; i++)
	   	  Serial.println(commandBuffer[i], );
    Serial.println("dispCmdBuffer ");
}

// void SerialCommands::loop()
// {

// //Do nothing
// }
// Tulasi
