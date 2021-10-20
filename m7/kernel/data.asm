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
; 		Current state of the 3 registers
;
RegA:
	.dw 	$0000
RegB:
	.dw 	$0000
RegC:
	.dw 	$0000
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
; 		Current work trying to do
;
CurrentWord:
	.dw 	0
;
; 		Buffer for reading word
;
wordBuffer:
	.ds 	17
;
;		Buffer for error messages
;	
ErrorBuffer:
	.ds 	17
;
; 		Random number generator
;
seed1:
	.dw 	$13A7
seed2:
	.dw 	$FEDC
;
;		Image Default Colour
;	
imageDefaultColour:
	.db 	$75