________________________________________
(1)
________________________________________
I introduced this variable below to control the program flow. It is used to flush the serial port buffer so that you will see a stable display via HyperTerminal. 
/* Program control */
/* By setting the inByte to 108 which is not assigned to any case in the switch construct, we can make the  HyperTerminal more user friendly */
#define inByteValueForCNTL 108
________________________________________
(2)________________________________________
Please use the values here to set up the loop counts:
// defalult values and configurations
int loopCountForSeq1 = 51; 
int loopCountForSeq2 = 52;
int loopCountForSeq3 = 53;
________________________________________
(3)________________________________________
These constants are introduced for capturing delays.
#define forLoopDelay 1
#define outerDelay 20
________________________________________
(4)________________________________________
A new case‘s’ is introduced for finding the state of the variables. You can add more here as required.
        case 's':
       case 'S':
        Serial.print("\r\nseq1RanOnce ="); Serial.print(seq1RanOnce, DEC); Serial.println(",Press 5 to clear flag \n");
        Serial.print("\r\nseq2RanOnce ="); Serial.print(seq2RanOnce, DEC); Serial.println(",Press 6 to clear flag \n");
        Serial.print("\r\nseq3RanOnce ="); Serial.print(seq3RanOnce, DEC); Serial.println(",Press 7 to clear flag \n");
        Serial.print("\r\nrunSeqOnceOnly ="); Serial.print(runSeqOnceOnly, DEC); Serial.println(",Press 9 to clear, Press 8 to set \n");
        inByte = inByteValueForCNTL;
       break;

