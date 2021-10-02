// *******************************************************************************************************************************
// *******************************************************************************************************************************
//
//		Name:		hardware.c
//		Purpose:	Hardware Emulation
//		Created:	30th September 2021
//		Author:		Paul Robson (paul@robsons.org.uk)
//
// *******************************************************************************************************************************
// *******************************************************************************************************************************

#include "sys_processor.h"
#include "hardware.h"
#include "gfx.h"
#include <stdlib.h>

static int soundPortState = 0;
static int lastToggleCycleTime = 0;
static int cycleToggleCount = 0;
static int cycleToggleTotal = 0;
static int tapeOffset = 0;

// *******************************************************************************************************************************
//												Reset Hardware
// *******************************************************************************************************************************

void HWReset(void) {	
	GFXSetFrequency(0);
	tapeOffset = 0;
	lastToggleCycleTime = 0;
}

// *******************************************************************************************************************************
//												  Reset CPU
// *******************************************************************************************************************************

void HWSync(void) {
	HWSyncImplementation(0);
	if (lastToggleCycleTime != 0 && cycleToggleCount > 4) {
		//
		//		The actual frequency is Clock Frequency (3.54Mhz) / 64 / Sound parameter.
		//
		int frequency = 280952*cycleToggleCount/cycleToggleTotal;
		GFXSetFrequency(frequency);
	} else {
		GFXSetFrequency(0);
	}
	lastToggleCycleTime = 0;
}

// *******************************************************************************************************************************
//												Port Read/Write
// *******************************************************************************************************************************

BYTE8 HWReadPort(WORD16 addr) {
	BYTE8 v = 0xFF;
	BYTE8 port = addr & 0xFF;

	if (port == 0xFF) {
		v = 0;
		for (int i = 0;i < 8;i++) {
			if ((addr & (0x0100 << i)) == 0) {
				v |= HWGetKeyboardRow(i);
			}
		}
		v ^= 0xFF;			
	}
	return v;
}

void HWWritePort(WORD16 addr,BYTE8 data) {
	BYTE8 port = addr & 0xFF;

	if (port == 0xFC && soundPortState != (data & 1)) {
		soundPortState = (data & 1);
		if (lastToggleCycleTime == 0) {
			cycleToggleCount = 0;
			cycleToggleTotal = 0;
		} else {
			cycleToggleCount++;
			cycleToggleTotal += abs(lastToggleCycleTime - CPUGetCycles());
		}
		lastToggleCycleTime = CPUGetCycles();
	}
}

// *******************************************************************************************************************************
// 									   Tape interface fake instructions
// *******************************************************************************************************************************

void HWSetTapeName(void) {
	char buffer[12];
	//
	// 		Get the filename in LC
	//
	for (int i = 0;i < 6;i++) buffer[i] = tolower(CPUReadMemory(LOADFILENAME+i));
	buffer[6] = '\0';
	strcat(buffer,".cqc");
	//
	// 		BASIC doesn't know it now. So it will load whatever we give it.
	//
	CPUWriteMemory(LOADFILENAME,0x00);
	//
	// 		Load it into the 16k "ROM" area. If it's actually a cartridge we'll reset it.
	//
	//printf("Actually want file %s\n",buffer);
	HWLoadFile(buffer,CPUGetUpper8kAddress());
	//
	// 		If it is really a cartridge, then reset the PC
	//
	if (CPUReadMemory(0xE005) == 0x9C && CPUReadMemory(0xE007) == 0xB0 && CPUReadMemory(0xE009) == 0x6C &&
		CPUReadMemory(0xE00B) == 0x64 && CPUReadMemory(0xE00D) == 0xA8 && CPUReadMemory(0xE00F) == 0x70) {
		CPUReset();
	}
	//
	// 		Rewind the tape offset.
	//
	tapeOffset = 0;
}

void HWReadTapeHeader(void) {
	BYTE8 b;
//	printf("Reading header\n");
	while(b = HWReadTapeByte(),b == 0x00) {}
	while(b = HWReadTapeByte(),b == 0xFF) {}
}

BYTE8 HWReadTapeByte(void) {
	if (tapeOffset == 0x4000) {
		CPUSetPC(0x1CA2);
	}
	BYTE8 b = *(CPUGetUpper8kAddress()+tapeOffset);
	tapeOffset++;
//	printf("Reading byte %d $%02x %c\n",b,b,(b & 0x7F) >= 0x20 ? (b & 0x7F) : '.');
	return b;
}
