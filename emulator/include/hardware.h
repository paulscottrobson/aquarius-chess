// *******************************************************************************************************************************
// *******************************************************************************************************************************
//
//		Name:		hardware.h
//		Purpose:	Hardware Emulation Header
//		Created:	30th September 2021
//		Author:		Paul Robson (paul@robsons.org.uk)
//
// *******************************************************************************************************************************
// *******************************************************************************************************************************

#ifndef _HARDWARE_H
#define _HARDWARE_H

void HWReset(void);
void HWSync(void);
BYTE8 HWReadPort(WORD16 addr);
void HWWritePort(WORD16 addr,BYTE8 data);

int HWGetKeyboardRow(int row);
void HWWriteVRAM(WORD16 address,BYTE8 data);
void HWSyncImplementation(LONG32 iCount);

void HWReadTapeHeader(void);
BYTE8 HWReadTapeByte(void);

#ifdef LINUX
#define FILESEP '/'
#else
#define FILESEP '\\'
#endif

#endif
