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

// *******************************************************************************************************************************
//												Reset Hardware
// *******************************************************************************************************************************

void HWReset(void) {	
	GFXSetFrequency(0);
}

// *******************************************************************************************************************************
//												  Reset CPU
// *******************************************************************************************************************************

void HWSync(void) {
	HWSyncImplementation(0);
	if (lastToggleCycleTime != 0) {
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
	BYTE8 v = 0;
	BYTE8 port = addr & 0xFF;

	if (port == 0xFF) {
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
