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
	.dw 	DictionaryInstalledBase
