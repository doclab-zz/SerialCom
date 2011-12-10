/*
  Serial Call and Response
 Language: Wiring/Arduino
 
 This program sends an ASCII A (byte of value 65) on startup
 and repeats that until it gets some data in.
 Then it waits for a byte in the serial port, and 
 sends three sensor values whenever it gets a byte in.
 
 Thanks to Greg Shakar and Scott Fitzgerald for the improvements
 
   The circuit:
 * potentiometers attached to analog inputs 0 and 1 
 * pushbutton attached to digital I/O 2
 
 Created 26 Sept. 2005
 by Tom Igoe
 Modified 4 Sep 2010
 by Tom Igoe and Scott Fitzgerald
Awwlwlwlwl
 This example code is in the public domain.

 http://www.arduino.cc/en/Tutorial/SerialCallResponse

 */
extern void loopALL();

int firstSensor = 0;    // first analog sensor
int secondSensor = 0;   // second analog sensor
int thirdSensor = 0;    // digital sensor
int inByte = 0;         // incoming serial byte

//---------------------------
//Variables for PUMP control 
//---------------------------
int pump1 = 10;         // PUMP connected to digital pin 10
int i;                  // loop count for pump control

// defalult values and configurations
int loopCountForSeq1 = 51; 
int loopCountForSeq2 = 52;
int loopCountForSeq3 = 53;

#define forLoopDelay 1
#define outerDelay 20

// Set this to 1 if you want to run the sequence once
// The value 0 will enable the sequence continuously by pressing the keys 1 or 2 or 3
int runSeqOnceOnly = 0;    

//sequence monitoring flags
int seq1RanOnce = 0;
int seq2RanOnce = 0;
int seq3RanOnce = 0;
int allSeqRanOnce =0;

/* Program control */
/* By setting the inByte to 108 which is not assigned to any case in the switch construct, we can make the 
HyperTerminal more user friendly */
#define inByteValueForCNTL 108


// Board setup 
void setup()
{
   pinMode(pump1, OUTPUT);      // sets the digital pin as output
  
  // start serial port at 9600 bps:
  Serial.begin(9600);
  pinMode(2, INPUT);   // digital sensor is on digital pin 2
  establishContact();  // send a byte to establish contact until receiver responds 
}

// Looping function provided by Arduino
void loop()
{

  // if we get a valid byte, read analog ins:
  if (Serial.available() > 0) {
    // get incoming byte:
    inByte = Serial.read();
    // read first analog input, divide by 4 to make the range 0-255:
    firstSensor = analogRead(A0)/4;
    // delay 10ms to let the ADC recover:
    delay(10);
    // read second analog input, divide by 4 to make the range 0-255:
    secondSensor = analogRead(1)/4;
    // read  switch, map it to 0 or 255L
    thirdSensor = map(digitalRead(2), 0, 1, 0, 255);  
    // send sensor values:
    Serial.print(firstSensor, BYTE);
    Serial.print(secondSensor, BYTE);
    Serial.print(thirdSensor, BYTE);               
  }
}

void establishContact() {
  while (Serial.available() <= 0) {
    Serial.print('A', BYTE);   // send a capital A
    delay(300);
  }
 
 for(;;)
 {    // Main loop to communcate between the board and PC
    if (Serial.available() > 0) { // if we get a valid byte
      // get incoming byte:
      inByte = Serial.read();
      if (runSeqOnceOnly == 1){
        Serial.println("\n\r Mode is set to run sequences once only ");
      }
 
      Serial.print("\n\rUser pressed key: ");
      Serial.print(inByte, BYTE);                   // send what is read
      Serial.print("\n\r");
    }
     
     switch(inByte){
       case '1':
          //run sequence 1
          Serial.println("\n\r--START-OF-SEQUENCE-1--");
          i=loopCountForSeq1;            // get the value from configuration
          for(i; i!=0; i--){
            if((seq1RanOnce == 1) && (runSeqOnceOnly ==1) )break; //if not set for continuous then break
            digitalWrite(pump1, HIGH);   // sets the pump1 on
            delay(1);                    // waits for a second
            digitalWrite(pump1, LOW);    // sets the pump1 off
            delay(1);                    // waits for a second
            Serial.print(i);             // print i
            Serial.print(' ', BYTE);
          }
          delay(outerDelay);
          seq1RanOnce = 1;
          Serial.println("\n\r--END-OF-SEQUENCE-1--");
          inByte = inByteValueForCNTL;
       break;
        
       case '2':
           //run sequence 2
          Serial.println("\n\r--START-OF-SEQUENCE-2--");
          i=loopCountForSeq2;            // get the value from configuration
          for(i; i!=0; i--){
            if((seq2RanOnce == 1) && (runSeqOnceOnly ==1) )break;  //if not set for continuous then break
            digitalWrite(pump1, HIGH);   // sets the pump1 on
            delay(5);                    // waits for a second
            digitalWrite(pump1, LOW);    // sets the pump1 off
            delay(5);                    // waits for a second
            Serial.print(i);             // print i
            Serial.print(' ', BYTE);

          }
         delay(outerDelay);
         seq2RanOnce = 1;
         Serial.println("\n\r--END-OF-SEQUENCE-2--");
         inByte = inByteValueForCNTL;
       break;
   
       case '3':
         //run sequence 3
         Serial.println("\n\r--START-OF-SEQUENCE-3--");
         i=loopCountForSeq3;            // get the value from configuration
         for(i; i!=0; i--){
           if((seq3RanOnce == 1) && (runSeqOnceOnly ==1) )break;  //if not set for continuous then break 
           digitalWrite(pump1, HIGH);   // sets the pump1 on
           delay(5);                    // waits for a second
           digitalWrite(pump1, LOW);    // sets the pump1 off
           delay(5);                    // waits for a second
           Serial.print(i);             // print i
           Serial.print(' ', BYTE);

         } 
          delay(outerDelay);
          seq3RanOnce =1;
          Serial.println("\n\r--END-OF-SEQUENCE-3--");
          inByte = inByteValueForCNTL;
       break;  
     
       case '4':
         runAllThreeSequences(loopCountForSeq1,loopCountForSeq2,loopCountForSeq3);
         inByte = inByteValueForCNTL;
       break;
       
       case '5':                      // Clear sequence1 monitor flag
         if (seq1RanOnce == 1) {
           seq1RanOnce =0;
           Serial.println("\n\r Sequence 1 ran once and it is set to run continuously now");
         }
       break;
       
       case '6':                      // Clear sequence2 monitor flag
         if (seq2RanOnce == 1) {
           seq2RanOnce =0;
           Serial.println("\n\r Sequence 2 ran once and it is set to run continuously now ");
         }
       break;
       
       case '7':                      // Clear sequence3 monitor flag
         if (seq3RanOnce == 1) {
           seq3RanOnce =0;
           Serial.println("\n\r Sequence 3 ran once and it is set to run continuously now ");
         }
       break;  
       
       case '8':                      // Toggle sequence repeat flag
         if (runSeqOnceOnly == 0){
           runSeqOnceOnly =1 ;
           Serial.println("\n\r Mode is set to run sequences for once only ");
         }
        break;
       
       case '9':                      // Toggle sequence repeat flag
         if (runSeqOnceOnly !=0){
         runSeqOnceOnly =0 ;
         Serial.println("\n\r Mode is set to run sequences for continious ");
         }
       break;
       
       case 's':
       case 'S':
        Serial.print("\r\nseq1RanOnce ="); Serial.print(seq1RanOnce, DEC); Serial.println(",Press 5 to clear flag \n");
        Serial.print("\r\nseq2RanOnce ="); Serial.print(seq2RanOnce, DEC); Serial.println(",Press 6 to clear flag \n");
        Serial.print("\r\nseq3RanOnce ="); Serial.print(seq3RanOnce, DEC); Serial.println(",Press 7 to clear flag \n");
        Serial.print("\r\nrunSeqOnceOnly ="); Serial.print(runSeqOnceOnly, DEC); Serial.println(",Press 9 to clear, Press 8 to set \n");
       
        inByte = inByteValueForCNTL;
       break;
        
        
       default:
          //Serial.println("\n\r-Unknown sequence number");
          //Serial.println("\b--Please press 1 or 2 or 3 or 4");
          //Serial.println("\r The selection 4 will run all the sequences 1,2 and 3");
          //inByte = inByteValueForCNTL;
         break;
     } 
 } // End of for loop. 
}

void runAllThreeSequences(int loopCntForSeq1, 
                          int loopCntForSeq2, 
                          int loopCntForSeq3){
                            
                          
  Serial.println("\n\r-Running All Sequences");

  Serial.println("\n\r-Running  Sequence 1");
  for(i= loopCntForSeq1; i!=0; i--)
  {
    if((seq1RanOnce == 1) && (runSeqOnceOnly ==1) ){
      Serial.println("\n\r-Skip Running  Sequence 1");
      break; //if not set for continuous then break
    }
    digitalWrite(pump1, HIGH);   // sets the LED on
    delay(5);                  // waits for a second
    digitalWrite(pump1, LOW);    // sets the LED off
    delay(5);                  // waits for a second
  }
  delay(outerDelay);
  
  Serial.println("\n\r-Running  Sequence 2");
  for(i=loopCntForSeq2; i!=0; i--)
  {
    if((seq2RanOnce == 1) && (runSeqOnceOnly ==1) ){
      Serial.println("\n\r-Skip Running  Sequence 2");
      break; //if not set for continuous then break
    }
    digitalWrite(pump1, HIGH);   // sets the LED on
    delay(5);                  // waits for a second
    digitalWrite(pump1, LOW);    // sets the LED off
    delay(5);                  // waits for a second
  }
 
  delay(outerDelay);
  
  Serial.println("\n\r-Running  Sequence 3");
  for(i=loopCntForSeq3; i!=0; i--)
  {
    if((seq3RanOnce == 1) && (runSeqOnceOnly ==1) ){
      Serial.println("\n\r-Skip Running  Sequence 3");
      break; //if not set for continuous then break
    }
    digitalWrite(pump1, HIGH);   // sets the LED on
    delay(5);                  // waits for a second
    digitalWrite(pump1, LOW);    // sets the LED off
    delay(5);                  // waits for a second
  } 
  Serial.println("\n\r\a\a-Completed Running All Sequences");
  allSeqRanOnce = 1;          //Indicate that all sequences ran once
}


/*
Processing sketch to run with this example:

// This example code is in the public domain.

import processing.serial.*;

int bgcolor;			     // Background color
int fgcolor;			     // Fill color
Serial myPort;                       // The serial port
int[] serialInArray = new int[3];    // Where we'll put what we receive
int serialCount = 0;                 // A count of how many bytes we receive
int xpos, ypos;		             // Starting position of the ball
boolean firstContact = false;        // Whether we've heard from the microcontroller

void setup() {
  size(256, 256);  // Stage size
  noStroke();      // No border on the next thing drawn

  // Set the starting position of the ball (middle of the stage)
  xpos = width/2;
  ypos = height/2;

  // Print a list of the serial ports, for debugging purposes:
  println(Serial.list());

  // I know that the first port in the serial list on my mac
  // is always my  FTDI adaptor, so I open Serial.list()[0].
  // On Windows machines, this generally opens COM1.
  // Open whatever port is the one you're using.
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
}

void draw() {
  background(bgcolor);
  fill(fgcolor);
  // Draw the shape
  ellipse(xpos, ypos, 20, 20);
}

void serialEvent(Serial myPort) {
  // read a byte from the serial port:
  int inByte = myPort.read();
  // if this is the first byte received, and it's an A,
  // clear the serial buffer and note that you've
  // had first contact from the microcontroller. 
  // Otherwise, add the incoming byte to the array:
  if (firstContact == false) {
    if (inByte == 'A') { 
      myPort.clear();          // clear the serial port buffer
      firstContact = true;     // you've had first contact from the microcontroller
      myPort.write('A');       // ask for more
    } 
  } 
  else {
    // Add the latest byte from the serial port to array:
    serialInArray[serialCount] = inByte;
    serialCount++;

    // If we have 3 bytes:
    if (serialCount > 2 ) {
      xpos = serialInArray[0];
      ypos = serialInArray[1];
      fgcolor = serialInArray[2];

      // print the values (for debugging purposes only):
      println(xpos + "\t" + ypos + "\t" + fgcolor);

      // Send a capital A to request new sensor readings:
      myPort.write('A');
      // Reset serialCount:
      serialCount = 0;
    }
  }
}
*/

/*
Max/MSP version 5 patch to run with this example:

{
	"boxes" : [ 		{
			"box" : 			{
				"maxclass" : "message",
				"text" : "65",
				"patching_rect" : [ 339.0, 466.0, 32.5, 18.0 ],
				"numoutlets" : 1,
				"fontsize" : 12.0,
				"outlettype" : [ "" ],
				"id" : "obj-9",
				"fontname" : "Arial",
				"numinlets" : 2
			}

		}
, 		{
			"box" : 			{
				"maxclass" : "newobj",
				"text" : "sel 1",
				"patching_rect" : [ 339.0, 437.0, 36.0, 20.0 ],
				"numoutlets" : 2,
				"fontsize" : 12.0,
				"outlettype" : [ "bang", "" ],
				"id" : "obj-6",
				"fontname" : "Arial",
				"numinlets" : 2
			}

		}
, 		{
			"box" : 			{
				"maxclass" : "comment",
				"text" : "Serial Call-Response  \n\nSends a byte out the serial port, and reads 3 bytes in.  Sets foregound color, xpos, and ypos of a circle using the values returned from the serial port.  \n\nNote: This patch assumes that the device on the other end of the serial port is going to send a single byte of value 65 (ASCII A) on startup. The sketch waits for that byte, then sends an ASCII A whenever it wants more data. \n\ncreated 14 Apr 2009\nby Scott Fitzgerald and Tom Igoe",
				"linecount" : 11,
				"patching_rect" : [ 404.0, 52.0, 464.0, 158.0 ],
				"numoutlets" : 0,
				"fontsize" : 12.0,
				"id" : "obj-5",
				"fontname" : "Arial",
				"numinlets" : 1
			}

		}
, 		{
			"box" : 			{
				"maxclass" : "comment",
				"text" : "trigger (or [t]) forces right-left conventions.  All the drawing and processing will happen before Max requests new values. When this trigger fires, it sends an ASCII A to ask Arduino for new values.",
				"linecount" : 3,
				"patching_rect" : [ 239.0, 505.0, 425.0, 48.0 ],
				"numoutlets" : 0,
				"fontsize" : 12.0,
				"id" : "obj-65",
				"fontname" : "Arial",
				"numinlets" : 1
			}

		}
, 		{
			"box" : 			{
				"maxclass" : "comment",
				"text" : "reinitializes the gates when turned on and off",
				"linecount" : 2,
				"patching_rect" : [ 170.0, 370.0, 135.0, 34.0 ],
				"numoutlets" : 0,
				"fontsize" : 12.0,
				"id" : "obj-64",
				"fontname" : "Arial",
				"numinlets" : 1
			}

		}
, 		{
			"box" : 			{
				"maxclass" : "comment",
				"text" : "checks for the ascii value of \"A\" to begin cominucation.  After initial communication is made, this block shuts down.",
				"linecount" : 3,
				"patching_rect" : [ 460.0, 355.0, 233.0, 48.0 ],
				"numoutlets" : 0,
				"fontsize" : 12.0,
				"id" : "obj-63",
				"fontname" : "Arial",
				"numinlets" : 1
			}

		}
, 		{
			"box" : 			{
				"maxclass" : "newobj",
				"text" : "p \"draw the circle\"",
				"patching_rect" : [ 217.0, 645.0, 269.0, 19.0 ],
				"numoutlets" : 1,
				"fontsize" : 10.0,
				"outlettype" : [ "" ],
				"id" : "obj-62",
				"fontname" : "Verdana",
				"numinlets" : 3,
				"patcher" : 				{
					"fileversion" : 1,
					"rect" : [ 54.0, 94.0, 640.0, 480.0 ],
					"bglocked" : 0,
					"defrect" : [ 54.0, 94.0, 640.0, 480.0 ],
					"openrect" : [ 0.0, 0.0, 0.0, 0.0 ],
					"openinpresentation" : 0,
					"default_fontsize" : 10.0,
					"default_fontface" : 0,
					"default_fontname" : "Verdana",
					"gridonopen" : 0,
					"gridsize" : [ 25.0, 25.0 ],
					"gridsnaponopen" : 0,
					"toolbarvisible" : 1,
					"boxanimatetime" : 200,
					"imprint" : 0,
					"boxes" : [ 						{
							"box" : 							{
								"maxclass" : "message",
								"text" : "frgb 255 255 255",
								"patching_rect" : [ 375.0, 150.0, 98.0, 18.0 ],
								"numoutlets" : 1,
								"fontsize" : 11.595187,
								"outlettype" : [ "" ],
								"id" : "obj-47",
								"fontname" : "Arial",
								"numinlets" : 2
							}

						}
, 						{
							"box" : 							{
								"maxclass" : "message",
								"text" : "frgb 0 0 0",
								"patching_rect" : [ 275.0, 125.0, 59.0, 18.0 ],
								"numoutlets" : 1,
								"fontsize" : 11.595187,
								"outlettype" : [ "" ],
								"id" : "obj-46",
								"fontname" : "Arial",
								"numinlets" : 2
							}

						}
, 						{
							"box" : 							{
								"maxclass" : "newobj",
								"text" : "sel 255 0",
								"patching_rect" : [ 300.0, 100.0, 66.0, 21.0 ],
								"numoutlets" : 3,
								"fontsize" : 12.0,
								"outlettype" : [ "bang", "bang", "" ],
								"id" : "obj-45",
								"fontname" : "Verdana",
								"numinlets" : 1
							}

						}
, 						{
							"box" : 							{
								"maxclass" : "newobj",
								"text" : "pack 0 0 0 0",
								"patching_rect" : [ 50.0, 125.0, 180.0, 21.0 ],
								"numoutlets" : 1,
								"fontsize" : 12.0,
								"outlettype" : [ "" ],
								"id" : "obj-43",
								"fontname" : "Verdana",
								"numinlets" : 4
							}

						}
, 						{
							"box" : 							{
								"maxclass" : "newobj",
								"text" : "+ 10",
								"patching_rect" : [ 200.0, 100.0, 40.0, 21.0 ],
								"numoutlets" : 1,
								"fontsize" : 12.0,
								"outlettype" : [ "int" ],
								"id" : "obj-42",
								"fontname" : "Verdana",
								"numinlets" : 2
							}

						}
, 						{
							"box" : 							{
								"maxclass" : "newobj",
								"text" : "+ 10",
								"patching_rect" : [ 75.0, 100.0, 40.0, 21.0 ],
								"numoutlets" : 1,
								"fontsize" : 12.0,
								"outlettype" : [ "int" ],
								"id" : "obj-41",
								"fontname" : "Verdana",
								"numinlets" : 2
							}

						}
, 						{
							"box" : 							{
								"maxclass" : "message",
								"text" : "clear, paintoval $1 $2 $3 $4",
								"patching_rect" : [ 50.0, 150.0, 152.0, 18.0 ],
								"numoutlets" : 1,
								"fontsize" : 11.595187,
								"outlettype" : [ "" ],
								"id" : "obj-40",
								"fontname" : "Arial",
								"numinlets" : 2
							}

						}
, 						{
							"box" : 							{
								"maxclass" : "inlet",
								"patching_rect" : [ 57.5, 40.0, 25.0, 25.0 ],
								"numoutlets" : 1,
								"outlettype" : [ "int" ],
								"id" : "obj-58",
								"numinlets" : 0,
								"comment" : ""
							}

						}
, 						{
							"box" : 							{
								"maxclass" : "inlet",
								"patching_rect" : [ 120.0, 40.0, 25.0, 25.0 ],
								"numoutlets" : 1,
								"outlettype" : [ "int" ],
								"id" : "obj-59",
								"numinlets" : 0,
								"comment" : ""
							}

						}
, 						{
							"box" : 							{
								"maxclass" : "inlet",
								"patching_rect" : [ 300.0, 40.0, 25.0, 25.0 ],
								"numoutlets" : 1,
								"outlettype" : [ "int" ],
								"id" : "obj-60",
								"numinlets" : 0,
								"comment" : ""
							}

						}
, 						{
							"box" : 							{
								"maxclass" : "outlet",
								"patching_rect" : [ 228.333344, 228.0, 25.0, 25.0 ],
								"numoutlets" : 0,
								"id" : "obj-61",
								"numinlets" : 1,
								"comment" : ""
							}

						}
 ],
					"lines" : [ 						{
							"patchline" : 							{
								"source" : [ "obj-47", 0 ],
								"destination" : [ "obj-61", 0 ],
								"hidden" : 0,
								"midpoints" : [  ]
							}

						}
, 						{
							"patchline" : 							{
								"source" : [ "obj-46", 0 ],
								"destination" : [ "obj-61", 0 ],
								"hidden" : 0,
								"midpoints" : [  ]
							}

						}
, 						{
							"patchline" : 							{
								"source" : [ "obj-40", 0 ],
								"destination" : [ "obj-61", 0 ],
								"hidden" : 0,
								"midpoints" : [  ]
							}

						}
, 						{
							"patchline" : 							{
								"source" : [ "obj-60", 0 ],
								"destination" : [ "obj-45", 0 ],
								"hidden" : 0,
								"midpoints" : [  ]
							}

						}
, 						{
							"patchline" : 							{
								"source" : [ "obj-59", 0 ],
								"destination" : [ "obj-42", 0 ],
								"hidden" : 0,
								"midpoints" : [  ]
							}

						}
, 						{
							"patchline" : 							{
								"source" : [ "obj-59", 0 ],
								"destination" : [ "obj-43", 1 ],
								"hidden" : 0,
								"midpoints" : [  ]
							}

						}
, 						{
							"patchline" : 							{
								"source" : [ "obj-58", 0 ],
								"destination" : [ "obj-41", 0 ],
								"hidden" : 0,
								"midpoints" : [  ]
							}

						}
, 						{
							"patchline" : 							{
								"source" : [ "obj-58", 0 ],
								"destination" : [ "obj-43", 0 ],
								"hidden" : 0,
								"midpoints" : [  ]
							}

						}
, 						{
							"patchline" : 							{
								"source" : [ "obj-42", 0 ],
								"destination" : [ "obj-43", 3 ],
								"hidden" : 0,
								"midpoints" : [  ]
							}

						}
, 						{
							"patchline" : 							{
								"source" : [ "obj-41", 0 ],
								"destination" : [ "obj-43", 2 ],
								"hidden" : 0,
								"midpoints" : [  ]
							}

						}
, 						{
							"patchline" : 							{
								"source" : [ "obj-45", 1 ],
								"destination" : [ "obj-47", 0 ],
								"hidden" : 0,
								"midpoints" : [  ]
							}

						}
, 						{
							"patchline" : 							{
								"source" : [ "obj-45", 0 ],
								"destination" : [ "obj-46", 0 ],
								"hidden" : 0,
								"midpoints" : [  ]
							}

						}
, 						{
							"patchline" : 							{
								"source" : [ "obj-43", 0 ],
								"destination" : [ "obj-40", 0 ],
								"hidden" : 0,
								"midpoints" : [  ]
							}

						}
 ]
				}
,
				"saved_object_attributes" : 				{
					"fontface" : 0,
					"fontsize" : 10.0,
					"default_fontface" : 0,
					"default_fontname" : "Verdana",
					"default_fontsize" : 10.0,
					"fontname" : "Verdana",
					"globalpatchername" : ""
				}

			}

		}
, 		{
			"box" : 			{
				"maxclass" : "newobj",
				"text" : "0",
				"patching_rect" : [ 310.0, 378.0, 32.5, 20.0 ],
				"numoutlets" : 1,
				"fontsize" : 12.0,
				"outlettype" : [ "int" ],
				"id" : "obj-57",
				"fontname" : "Arial",
				"numinlets" : 2
			}

		}
, 		{
			"box" : 			{
				"maxclass" : "newobj",
				"text" : "!- 1",
				"patching_rect" : [ 385.0, 436.0, 32.5, 20.0 ],
				"numoutlets" : 1,
				"fontsize" : 12.0,
				"outlettype" : [ "int" ],
				"id" : "obj-55",
				"fontname" : "Arial",
				"numinlets" : 2
			}

		}
, 		{
			"box" : 			{
				"maxclass" : "newobj",
				"text" : "gate 1 1",
				"patching_rect" : [ 385.0, 355.0, 54.0, 20.0 ],
				"numoutlets" : 1,
				"fontsize" : 12.0,
				"outlettype" : [ "" ],
				"id" : "obj-54",
				"fontname" : "Arial",
				"numinlets" : 2
			}

		}
, 		{
			"box" : 			{
				"maxclass" : "toggle",
				"patching_rect" : [ 385.0, 405.0, 20.0, 20.0 ],
				"numoutlets" : 1,
				"outlettype" : [ "int" ],
				"id" : "obj-53",
				"numinlets" : 1
			}

		}
, 		{
			"box" : 			{
				"maxclass" : "newobj",
				"text" : "gate 1 0",
				"patching_rect" : [ 194.0, 455.0, 54.0, 20.0 ],
				"numoutlets" : 1,
				"fontsize" : 12.0,
				"outlettype" : [ "" ],
				"id" : "obj-50",
				"fontname" : "Arial",
				"numinlets" : 2
			}

		}
, 		{
			"box" : 			{
				"maxclass" : "newobj",
				"text" : "sel 65",
				"patching_rect" : [ 385.0, 380.0, 43.0, 20.0 ],
				"numoutlets" : 2,
				"fontsize" : 12.0,
				"outlettype" : [ "bang", "" ],
				"id" : "obj-48",
				"fontname" : "Arial",
				"numinlets" : 2
			}

		}
, 		{
			"box" : 			{
				"maxclass" : "lcd",
				"patching_rect" : [ 217.0, 695.0, 256.0, 256.0 ],
				"numoutlets" : 4,
				"outlettype" : [ "list", "list", "int", "" ],
				"id" : "obj-39",
				"numinlets" : 1
			}

		}
, 		{
			"box" : 			{
				"maxclass" : "newobj",
				"text" : "t 65 l",
				"patching_rect" : [ 194.0, 504.0, 42.0, 21.0 ],
				"numoutlets" : 2,
				"fontsize" : 12.0,
				"outlettype" : [ "int", "" ],
				"id" : "obj-35",
				"fontname" : "Verdana",
				"numinlets" : 1
			}

		}
, 		{
			"box" : 			{
				"maxclass" : "comment",
				"text" : "val3",
				"patching_rect" : [ 535.0, 604.0, 37.0, 21.0 ],
				"numoutlets" : 0,
				"fontsize" : 12.0,
				"id" : "obj-1",
				"fontname" : "Verdana",
				"numinlets" : 1
			}

		}
, 		{
			"box" : 			{
				"maxclass" : "number",
				"patching_rect" : [ 467.0, 604.0, 56.0, 21.0 ],
				"numoutlets" : 2,
				"fontsize" : 12.0,
				"outlettype" : [ "int", "bang" ],
				"id" : "obj-3",
				"fontname" : "Verdana",
				"numinlets" : 1
			}

		}
, 		{
			"box" : 			{
				"maxclass" : "comment",
				"text" : "val2",
				"patching_rect" : [ 410.0, 605.0, 37.0, 21.0 ],
				"numoutlets" : 0,
				"fontsize" : 12.0,
				"id" : "obj-18",
				"fontname" : "Verdana",
				"numinlets" : 1
			}

		}
, 		{
			"box" : 			{
				"maxclass" : "comment",
				"text" : "val1",
				"patching_rect" : [ 282.0, 605.0, 37.0, 21.0 ],
				"numoutlets" : 0,
				"fontsize" : 12.0,
				"id" : "obj-20",
				"fontname" : "Verdana",
				"numinlets" : 1
			}

		}
, 		{
			"box" : 			{
				"maxclass" : "number",
				"patching_rect" : [ 342.0, 605.0, 56.0, 21.0 ],
				"numoutlets" : 2,
				"fontsize" : 12.0,
				"outlettype" : [ "int", "bang" ],
				"id" : "obj-22",
				"fontname" : "Verdana",
				"numinlets" : 1
			}

		}
, 		{
			"box" : 			{
				"maxclass" : "number",
				"patching_rect" : [ 217.0, 605.0, 55.0, 21.0 ],
				"numoutlets" : 2,
				"fontsize" : 12.0,
				"outlettype" : [ "int", "bang" ],
				"id" : "obj-23",
				"fontname" : "Verdana",
				"numinlets" : 1
			}

		}
, 		{
			"box" : 			{
				"maxclass" : "newobj",
				"text" : "unpack 0 0 0",
				"patching_rect" : [ 217.0, 570.0, 269.0, 21.0 ],
				"numoutlets" : 3,
				"fontsize" : 12.0,
				"outlettype" : [ "int", "int", "int" ],
				"id" : "obj-29",
				"fontname" : "Verdana",
				"numinlets" : 1
			}

		}
, 		{
			"box" : 			{
				"maxclass" : "newobj",
				"text" : "zl group 3",
				"patching_rect" : [ 194.0, 480.0, 71.0, 21.0 ],
				"numoutlets" : 2,
				"fontsize" : 12.0,
				"outlettype" : [ "", "" ],
				"id" : "obj-31",
				"fontname" : "Verdana",
				"numinlets" : 2
			}

		}
, 		{
			"box" : 			{
				"maxclass" : "newobj",
				"text" : "select 0 1",
				"patching_rect" : [ 312.0, 200.0, 62.0, 20.0 ],
				"numoutlets" : 3,
				"fontsize" : 12.0,
				"outlettype" : [ "bang", "bang", "" ],
				"id" : "obj-30",
				"fontname" : "Arial",
				"numinlets" : 1
			}

		}
, 		{
			"box" : 			{
				"maxclass" : "comment",
				"text" : "click here to close the serial port",
				"patching_rect" : [ 360.0, 291.0, 206.0, 20.0 ],
				"numoutlets" : 0,
				"fontsize" : 12.0,
				"id" : "obj-26",
				"fontname" : "Arial",
				"numinlets" : 1
			}

		}
, 		{
			"box" : 			{
				"maxclass" : "comment",
				"text" : "click here to open the serial port",
				"patching_rect" : [ 385.0, 265.0, 206.0, 20.0 ],
				"numoutlets" : 0,
				"fontsize" : 12.0,
				"id" : "obj-27",
				"fontname" : "Arial",
				"numinlets" : 1
			}

		}
, 		{
			"box" : 			{
				"maxclass" : "message",
				"text" : "close",
				"patching_rect" : [ 312.0, 291.0, 39.0, 18.0 ],
				"numoutlets" : 1,
				"fontsize" : 12.0,
				"outlettype" : [ "" ],
				"id" : "obj-21",
				"fontname" : "Arial",
				"numinlets" : 2
			}

		}
, 		{
			"box" : 			{
				"maxclass" : "message",
				"text" : "port a",
				"patching_rect" : [ 334.0, 265.0, 41.0, 18.0 ],
				"numoutlets" : 1,
				"fontsize" : 12.0,
				"outlettype" : [ "" ],
				"id" : "obj-19",
				"fontname" : "Arial",
				"numinlets" : 2
			}

		}
, 		{
			"box" : 			{
				"maxclass" : "comment",
				"text" : "Click here to get a list of serial ports",
				"patching_rect" : [ 405.0, 239.0, 207.0, 20.0 ],
				"numoutlets" : 0,
				"fontsize" : 12.0,
				"id" : "obj-2",
				"fontname" : "Arial",
				"numinlets" : 1
			}

		}
, 		{
			"box" : 			{
				"maxclass" : "toggle",
				"patching_rect" : [ 229.0, 155.0, 22.0, 22.0 ],
				"numoutlets" : 1,
				"outlettype" : [ "int" ],
				"id" : "obj-11",
				"numinlets" : 1
			}

		}
, 		{
			"box" : 			{
				"maxclass" : "newobj",
				"text" : "qmetro 10",
				"patching_rect" : [ 229.0, 200.0, 65.0, 20.0 ],
				"numoutlets" : 1,
				"fontsize" : 12.0,
				"outlettype" : [ "bang" ],
				"id" : "obj-12",
				"fontname" : "Arial",
				"numinlets" : 2
			}

		}
, 		{
			"box" : 			{
				"maxclass" : "message",
				"text" : "print",
				"patching_rect" : [ 354.0, 239.0, 36.0, 18.0 ],
				"numoutlets" : 1,
				"fontsize" : 12.0,
				"outlettype" : [ "" ],
				"id" : "obj-13",
				"fontname" : "Arial",
				"numinlets" : 2
			}

		}
, 		{
			"box" : 			{
				"maxclass" : "newobj",
				"text" : "serial a 9600",
				"patching_rect" : [ 229.0, 315.0, 84.0, 20.0 ],
				"numoutlets" : 2,
				"fontsize" : 12.0,
				"outlettype" : [ "int", "" ],
				"id" : "obj-14",
				"fontname" : "Arial",
				"numinlets" : 1
			}

		}
, 		{
			"box" : 			{
				"maxclass" : "comment",
				"text" : "Read serial input buffer every 10 milliseconds",
				"linecount" : 2,
				"patching_rect" : [ 13.0, 192.0, 210.0, 34.0 ],
				"numoutlets" : 0,
				"fontsize" : 12.0,
				"id" : "obj-15",
				"fontname" : "Arial",
				"numinlets" : 1
			}

		}
, 		{
			"box" : 			{
				"maxclass" : "comment",
				"text" : "Click to start",
				"patching_rect" : [ 256.0, 163.0, 117.0, 20.0 ],
				"numoutlets" : 0,
				"fontsize" : 12.0,
				"id" : "obj-17",
				"fontname" : "Arial",
				"numinlets" : 1
			}

		}
 ],
	"lines" : [ 		{
			"patchline" : 			{
				"source" : [ "obj-12", 0 ],
				"destination" : [ "obj-14", 0 ],
				"hidden" : 0,
				"midpoints" : [  ]
			}

		}
, 		{
			"patchline" : 			{
				"source" : [ "obj-11", 0 ],
				"destination" : [ "obj-12", 0 ],
				"hidden" : 0,
				"midpoints" : [  ]
			}

		}
, 		{
			"patchline" : 			{
				"source" : [ "obj-13", 0 ],
				"destination" : [ "obj-14", 0 ],
				"hidden" : 0,
				"midpoints" : [ 363.5, 260.5, 238.5, 260.5 ]
			}

		}
, 		{
			"patchline" : 			{
				"source" : [ "obj-19", 0 ],
				"destination" : [ "obj-14", 0 ],
				"hidden" : 0,
				"midpoints" : [ 343.5, 288.5, 238.5, 288.5 ]
			}

		}
, 		{
			"patchline" : 			{
				"source" : [ "obj-21", 0 ],
				"destination" : [ "obj-14", 0 ],
				"hidden" : 0,
				"midpoints" : [ 321.5, 311.5, 238.5, 311.5 ]
			}

		}
, 		{
			"patchline" : 			{
				"source" : [ "obj-30", 0 ],
				"destination" : [ "obj-21", 0 ],
				"hidden" : 0,
				"midpoints" : [  ]
			}

		}
, 		{
			"patchline" : 			{
				"source" : [ "obj-30", 1 ],
				"destination" : [ "obj-19", 0 ],
				"hidden" : 0,
				"midpoints" : [  ]
			}

		}
, 		{
			"patchline" : 			{
				"source" : [ "obj-11", 0 ],
				"destination" : [ "obj-30", 0 ],
				"hidden" : 0,
				"midpoints" : [ 238.5, 191.0, 321.5, 191.0 ]
			}

		}
, 		{
			"patchline" : 			{
				"source" : [ "obj-29", 2 ],
				"destination" : [ "obj-3", 0 ],
				"hidden" : 0,
				"midpoints" : [  ]
			}

		}
, 		{
			"patchline" : 			{
				"source" : [ "obj-29", 0 ],
				"destination" : [ "obj-23", 0 ],
				"hidden" : 0,
				"midpoints" : [  ]
			}

		}
, 		{
			"patchline" : 			{
				"source" : [ "obj-29", 1 ],
				"destination" : [ "obj-22", 0 ],
				"hidden" : 0,
				"midpoints" : [  ]
			}

		}
, 		{
			"patchline" : 			{
				"source" : [ "obj-14", 0 ],
				"destination" : [ "obj-50", 1 ],
				"hidden" : 0,
				"midpoints" : [  ]
			}

		}
, 		{
			"patchline" : 			{
				"source" : [ "obj-50", 0 ],
				"destination" : [ "obj-31", 0 ],
				"hidden" : 0,
				"midpoints" : [  ]
			}

		}
, 		{
			"patchline" : 			{
				"source" : [ "obj-48", 0 ],
				"destination" : [ "obj-53", 0 ],
				"hidden" : 0,
				"midpoints" : [  ]
			}

		}
, 		{
			"patchline" : 			{
				"source" : [ "obj-53", 0 ],
				"destination" : [ "obj-50", 0 ],
				"hidden" : 0,
				"midpoints" : [ 394.5, 426.0, 203.5, 426.0 ]
			}

		}
, 		{
			"patchline" : 			{
				"source" : [ "obj-14", 0 ],
				"destination" : [ "obj-54", 1 ],
				"hidden" : 0,
				"midpoints" : [ 238.5, 342.0, 429.5, 342.0 ]
			}

		}
, 		{
			"patchline" : 			{
				"source" : [ "obj-54", 0 ],
				"destination" : [ "obj-48", 0 ],
				"hidden" : 0,
				"midpoints" : [  ]
			}

		}
, 		{
			"patchline" : 			{
				"source" : [ "obj-62", 0 ],
				"destination" : [ "obj-39", 0 ],
				"hidden" : 0,
				"midpoints" : [  ]
			}

		}
, 		{
			"patchline" : 			{
				"source" : [ "obj-3", 0 ],
				"destination" : [ "obj-62", 2 ],
				"hidden" : 0,
				"midpoints" : [  ]
			}

		}
, 		{
			"patchline" : 			{
				"source" : [ "obj-22", 0 ],
				"destination" : [ "obj-62", 1 ],
				"hidden" : 0,
				"midpoints" : [  ]
			}

		}
, 		{
			"patchline" : 			{
				"source" : [ "obj-23", 0 ],
				"destination" : [ "obj-62", 0 ],
				"hidden" : 0,
				"midpoints" : [  ]
			}

		}
, 		{
			"patchline" : 			{
				"source" : [ "obj-53", 0 ],
				"destination" : [ "obj-55", 0 ],
				"hidden" : 0,
				"midpoints" : [  ]
			}

		}
, 		{
			"patchline" : 			{
				"source" : [ "obj-55", 0 ],
				"destination" : [ "obj-54", 0 ],
				"hidden" : 0,
				"midpoints" : [ 394.5, 459.0, 453.0, 459.0, 453.0, 351.0, 394.5, 351.0 ]
			}

		}
, 		{
			"patchline" : 			{
				"source" : [ "obj-30", 0 ],
				"destination" : [ "obj-57", 0 ],
				"hidden" : 0,
				"midpoints" : [  ]
			}

		}
, 		{
			"patchline" : 			{
				"source" : [ "obj-57", 0 ],
				"destination" : [ "obj-53", 0 ],
				"hidden" : 0,
				"midpoints" : [ 319.5, 401.0, 394.5, 401.0 ]
			}

		}
, 		{
			"patchline" : 			{
				"source" : [ "obj-35", 0 ],
				"destination" : [ "obj-14", 0 ],
				"hidden" : 0,
				"midpoints" : [ 203.5, 542.0, 167.0, 542.0, 167.0, 300.0, 238.5, 300.0 ]
			}

		}
, 		{
			"patchline" : 			{
				"source" : [ "obj-35", 1 ],
				"destination" : [ "obj-29", 0 ],
				"hidden" : 0,
				"midpoints" : [  ]
			}

		}
, 		{
			"patchline" : 			{
				"source" : [ "obj-31", 0 ],
				"destination" : [ "obj-35", 0 ],
				"hidden" : 0,
				"midpoints" : [  ]
			}

		}
, 		{
			"patchline" : 			{
				"source" : [ "obj-6", 0 ],
				"destination" : [ "obj-9", 0 ],
				"hidden" : 0,
				"midpoints" : [  ]
			}

		}
, 		{
			"patchline" : 			{
				"source" : [ "obj-53", 0 ],
				"destination" : [ "obj-6", 0 ],
				"hidden" : 0,
				"midpoints" : [ 394.5, 431.5, 348.5, 431.5 ]
			}

		}
, 		{
			"patchline" : 			{
				"source" : [ "obj-9", 0 ],
				"destination" : [ "obj-14", 0 ],
				"hidden" : 0,
				"midpoints" : [  ]
			}

		}
 ]
}


*/
