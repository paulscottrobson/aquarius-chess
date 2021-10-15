; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		m7.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		15th October 2021
;		Purpose :	M7 Main.
;
; ***************************************************************************************
; ***************************************************************************************

CodeStart = 0xC000
CodeEnd = 0xFFFF

	.org CodeStart

; ***************************************************************************************
;
; 									  Code Header
;
; ***************************************************************************************

start: 								
	ld 		sp,(StackPointer) 				; have a workable stack
	ld 		hl,(StartAddress) 				; running from here
	jp 		(hl) 							

	.org 	start+16 						; information area
	.word 	start 							; +$10 base address of kernel
	.word 	DataArea  						; +$12 address of data area.
	.word	CopyFollowing  					; +$14 utility function addresses
	.word	CompileCallFollowing
	.word	CompileWord
	.word	CompileByte

	.include "data.asm" 					; data area.
	.include "kernel/kernel.asm"			; kernel code.	

; ***************************************************************************************
;
; 							Autogenerated Vocabulary file
;
; ***************************************************************************************

	.include 	"vocabulary/vocabulary.asm"
FreeSpace:

; ***************************************************************************************
;
;										ROM Header
;
; ***************************************************************************************

	.org	$E000
	.db  	"PSR",0 						; 4 bytes filler.
	.db  	0,$9C,0,$B0,0,$6C 				; 12 bytes ROM Identify
	.db 	0,$64,0,$A8,$5F,$70 			; the $5F makes the total $70 so $00 is output to scrambler
	.org 	$E010
	jp 		start 							; BIOS enters here.

; ***************************************************************************************
;
; 				Load the Dictionary into High memory, it works down.
;
; ***************************************************************************************

	.include "vocabulary/dictionary.inc" 	; get length
	.org 	CodeEnd-DictionarySize+1 		; set start pointer
DictionaryInstalledBase:
	.include "vocabulary/dictionary.asm" 	; pregenerated dictionary.