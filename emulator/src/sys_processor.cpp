// *******************************************************************************************************************************
// *******************************************************************************************************************************
//
//		Name:		sys_processor.cpp
//		Purpose:	Processor Emulation.
//		Created:	30th September 2021
//		Author:		Paul Robson (paul@robsons.org.uk)
//
// *******************************************************************************************************************************
// *******************************************************************************************************************************

#include <stdio.h>
#include "sys_processor.h"
#include "sys_debug_system.h"
#include "hardware.h"

// *******************************************************************************************************************************
//														   Timing
// *******************************************************************************************************************************

#define CYCLE_RATE 		(3540*1000)													// Cycles per second (3.54Mhz)
#define FRAME_RATE		(60)														// Frames per second (50 arbitrary)
#define CYCLES_PER_FRAME (CYCLE_RATE / FRAME_RATE / 6)								// We count in units of multiple Z80 Cycles.				

// *******************************************************************************************************************************
//														CPU / Memory
// *******************************************************************************************************************************

static BYTE8 A,B,C,D,E,H,L;  														// Standard register
static WORD16 AFalt,BCalt,DEalt,HLalt; 												// Alternate data set.
static WORD16 PC,SP; 																// 16 bit registers
static WORD16 IX,IY; 																// IX IY accessed indirectly.

static BYTE8 s_Flag,z_Flag,c_Flag,h_Flag,n_Flag,p_Flag; 							// Flag Registers
static BYTE8 I,R,intEnabled; 														// We don't really bother with these much.

static BYTE8 ramMemory[RAMSIZE];													// Memory at $0000 upwards

static LONG32 temp32;
static WORD16 temp16,temp16a,*pIXY;
static BYTE8 temp8,oldCarry;

static WORD16 cycles;																// Cycle Count.
static WORD16 cyclesPerFrame = CYCLES_PER_FRAME;									// Cycles per frame

// *******************************************************************************************************************************
//											 Memory and I/O read and write macros.
// *******************************************************************************************************************************

#define READ8(a) 	_Read(a)														// Basic Read
#define WRITE8(a,d)	_Write(a,d)														// Basic Write

#define READ16(a) 	(READ8(a) | ((READ8((a)+1) << 8)))								// Read 16 bits.
#define WRITE16(a,d) { WRITE8(a,(d) & 0xFF);WRITE8((a)+1,(d) >> 8); } 				// Write 16 bits

#define FETCH8() 	READ8(PC++)														// Fetch byte
#define FETCH16()	_Fetch16()	 													// Fetch word

static inline BYTE8 _Read(WORD16 address);											// Need to be forward defined as 
static inline void _Write(WORD16 address,BYTE8 data);								// used in support functions.

#define INPORT(p) 	(0xAA)
#define OUTPORT(p,d) { if (p == 0xFF) _VerifyCode(); }

// *******************************************************************************************************************************
//														Verify code
// *******************************************************************************************************************************

static void _VerifyCode(void) {
	if (C == 9) {
		int p = (D<<8)|E;
		while (ramMemory[p] != '$') printf("%c",ramMemory[p++]);
	} else {
		printf("%x %x %x\n",C,D,E);
	}
}

// *******************************************************************************************************************************
//											   Read and Write Inline Functions
// *******************************************************************************************************************************

static inline BYTE8 _Read(WORD16 address) {
	return ramMemory[address];							
}

static void _Write(WORD16 address,BYTE8 data) {
	ramMemory[address] = data;
}

static WORD16 _Fetch16(void) {
	WORD16 w = READ16(PC);
	PC += 2;
	return w;
}

// *******************************************************************************************************************************
//											 Support macros and functions
// *******************************************************************************************************************************

#ifdef INCLUDE_DEBUGGING_SUPPORT
#include <stdlib.h>
#define FAILOPCODE(g,n) exit(fprintf(stderr,"Opcode %02x in group %s\n",n,g))
#else
#define FAILOPCODE(g,n) {}
#endif

#include "cpu_support.h"

// *******************************************************************************************************************************
//														Reset the CPU
// *******************************************************************************************************************************

#ifdef INCLUDE_DEBUGGING_SUPPORT
static void CPULoadChunk(FILE *f,BYTE8* memory,int count);
#endif

void CPUReset(void) {
	HWReset();																		// Reset Hardware
	BuildParityTable();																// Build the parity flag table.
	PC = 0; 																		// Zero PC.
}

// *******************************************************************************************************************************
//					Called on exit, does nothing on ESP32 but required for compilation
// *******************************************************************************************************************************

#ifdef INCLUDE_DEBUGGING_SUPPORT
#include "gfx.h"
void CPUExit(void) {	
	printf("Exited via $FFFF");
	GFXExit();
}
#else
void CPUExit(void) {}
#endif

// *******************************************************************************************************************************
//												Execute a single instruction
// *******************************************************************************************************************************

BYTE8 CPUExecuteInstruction(void) {
	#ifdef INCLUDE_DEBUGGING_SUPPORT
	if (PC == 0xFFFF) CPUExit();
	#endif
	BYTE8 opcode = FETCH8();														// Fetch opcode.
	switch(opcode) {																// Execute it.
		#include "_code_group_0.h"
		default:
			FAILOPCODE("-",opcode);
	}
	cycles++; 																		// One instruction/cycle approximation
	if (cycles < cyclesPerFrame) return 0;											// Not completed a frame.
	cycles = cycles - cyclesPerFrame;												// Adjust this frame rate.
	HWSync();																		// Update any hardware
	return FRAME_RATE;																// Return frame rate.
}

// *******************************************************************************************************************************
//												Read/Write Memory
// *******************************************************************************************************************************

BYTE8 CPUReadMemory(WORD16 address) {
	return READ8(address);
}

void CPUWriteMemory(WORD16 address,BYTE8 data) {
	WRITE8(address,data);
}

#ifdef INCLUDE_DEBUGGING_SUPPORT

// *******************************************************************************************************************************
//		Execute chunk of code, to either of two break points or frame-out, return non-zero frame rate on frame, breakpoint 0
// *******************************************************************************************************************************

BYTE8 CPUExecute(WORD16 breakPoint1,WORD16 breakPoint2) { 
	BYTE8 next;
	do {
		BYTE8 r = CPUExecuteInstruction();											// Execute an instruction
		if (r != 0) return r; 														// Frame out.
		next = CPUReadMemory(PC);
	} while (PC != breakPoint1 && PC != breakPoint2 && next != 0x76);				// Stop on breakpoint or $76 HALT break
	return 0; 
}

// *******************************************************************************************************************************
//									Return address of breakpoint for step-over, or 0 if N/A
// *******************************************************************************************************************************

WORD16 CPUGetStepOverBreakpoint(void) {
	// TODO: Complete for Z80 CALL CALL cond and RST
	return 0;																		// Do a normal single step
}

void CPUEndRun(void) {
	FILE *f = fopen("memory.dump","wb");
	fwrite(ramMemory,1,RAMSIZE,f);
	fclose(f);
}

static void CPULoadChunk(FILE *f,BYTE8* memory,int count) {
	while (count != 0) {
		int qty = (count > 4096) ? 4096 : count;
		fread(memory,1,qty,f);
		count = count - qty;
		memory = memory + qty;
	}
}
void CPULoadBinary(char *fileName) {
	FILE *f = fopen(fileName,"rb");
	if (f != NULL) {
		CPULoadChunk(f,ramMemory,RAMSIZE);
		fclose(f);
	}
}

// *******************************************************************************************************************************
//											Retrieve a snapshot of the processor
// *******************************************************************************************************************************

static CPUSTATUS st;																	// Status area

CPUSTATUS *CPUGetStatus(void) {
	st.AF = AF();
	st.BC = BC();
	st.DE = DE();
	st.HL = HL();
	st.AFalt = AFalt;
	st.BCalt = BCalt;
	st.DEalt = DEalt;
	st.HLalt = HLalt;
	st.PC = PC;
	st.SP = SP;
	st.IX = IX;
	st.IY = IY;
	st.IE = intEnabled;
	st.cycles = cycles;
	return &st;
}

#endif