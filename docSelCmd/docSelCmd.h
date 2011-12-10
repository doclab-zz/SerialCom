// -*- mode: c++ -*-


// Arduino DOC Serial Command Library (docSelCmd)


#ifndef DOCSELCMD_H
#define DOCSELCMD_H

//void loop();

class SerialCommands{
  public:
    SerialCommands();
    void cmdDecode();
	void dispCmdBuffer();
	void setupSerialPort(int serialPortSpeed , int commandBufferSize);
	char commandBuffer[5];
	//void loop();
  private:
    int _serialPortSpeed;
	int _commandBufferSize;
	
};


#endif	// DOCSELCMD_H

// Tulasi
