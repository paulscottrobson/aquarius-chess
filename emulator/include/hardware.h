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
void HWWriteVRAM(WORD16 address,BYTE8 data);
void HWSyncImplementation(LONG32 iCount);

#ifdef LINUX
#define FILESEP '/'
#else
#define FILESEP '\\'
#endif

#endif
