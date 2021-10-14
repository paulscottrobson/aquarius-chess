// *******************************************************************************************************************************
// *******************************************************************************************************************************
//
//		Name:		hardware.h
//		Purpose:	Hardware Emulation Header
//		Created:	1st October 2021
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
void HWReadTapeHeader(void);
BYTE8 HWReadTapeByte(void);
void HWSetTapeName(void);

void HWXWriteVRAM(WORD16 address,BYTE8 data);
void HWXSyncImplementation(LONG32 iCount);
void HWXSetFrequency(int frequency);
int  HWXIsKeyPressed(int keyNumber);
void HWXLoadDirectory(BYTE8 *target);
WORD16 HWXLoadFile(char * fileName,BYTE8 *target);
WORD16 HWXGetSystemClock(void);

#define LOADFILENAME (0x3851)

#ifdef LINUX
#define FILESEP '/'
#else
#define FILESEP '\\'
#endif

#endif
