; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		data.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		15th October 2021
;		Purpose :	Data 
;
; ***************************************************************************************
; ***************************************************************************************


; ***************************************************************************************
;
;										Data Area
;
; ***************************************************************************************

DataArea:
;
; 		Initial Stack Pointer
;
StackPointer:
	.dw 	$3FFF
;
; 		Next free code byte
;
CodeNextFree:
	.dw 	FreeSpace
;
; 		Execute address for startup
;
StartAddress:	
	.dw 	Main
;
; 		Dictionary start (works down)
;
DictionaryBase:
	.dw 	DictionaryInstalledBase
;
; 		Current state of the 3 registers
;
RegA:
	.dw 	$0000
RegB:
	.dw 	$0000
RegC:
	.dw 	$0000
