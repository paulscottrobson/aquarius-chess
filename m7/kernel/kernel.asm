; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		kernel.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		14th October 2021
;		Purpose :	Kernel Main Program
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
; 									Entry point
;
; ***************************************************************************************

Main:
		ld 		sp,(StackPointer)			; reset Stack Pointer
		ld 		hl,wordBuffer
_MainRead:
		.db 	$ED,$FF 					; read character
		or 		a 							; warm start if zero
		jr 		z,WarmStart
		ld 		b,a 						; save
		and 	$3F
		cp 		$20 						; check if it is space
		jr 		z,_MainRead 				; if so, go round again
_MainCopy:
		ld 		(hl),b 						; copy word out.
		inc 	hl
		.db 	$ED,$FF 					; read character
		or 		a 							; end if zero.
		jr 		z,_MainHaveWord
		ld 		b,a				
		and 	$3F
		cp 		$20 						; check if it is space
		jr 		nz,_MainCopy 				; if not keep copying
_MainHaveWord:		
		ld 		(hl),$00 					; mark word end.
		ld 		hl,wordBuffer 				; compile it
		call 	CompileOne
		jr 		_MainRead 					; and loop round.

; ***************************************************************************************
;
; 										Warm Start
;
; ***************************************************************************************

WarmStart:
		xor 	a
		ld 		(ErrorBuffer),a

; ***************************************************************************************
;
; 								Access the user interface
;
; ***************************************************************************************

Interface:		
		ld 		hl,ErrorBuffer 				; point HL to Error Buffer
		ld 		sp,(StackPointer)			; reset Stack Pointer
		ld 		bc,(InformationBlock+2)
		push 	bc
		ret

; ***************************************************************************************
;
; 							The default 'user interface' - nothing.
;
; ***************************************************************************************

InterfaceHandler:		
		ld 		de,$EEEE
		ld 		bc,$EEEE
		halt
		jr 		InterfaceHandler
;
; 		Word cannot be executed error
;
WordIsCompileOnly:
		ld 		a,'C'
		jr 		SetErrorBuffer
;
; 		Unknown word error
;
UnknownWord:
		ld 		a,'?'
;
; 		Report error, copy char to error buffer, then space, then current word.
;		
SetErrorBuffer:
		ld 		hl,ErrorBuffer
		ld 		(hl),a
		inc 	hl
		ld 		(hl),' '
		inc 	hl
		ld 		de,(CurrentWord)
_SEBCopy:
		ld 		(hl),0
		ld 		a,(de)
		or  	a
		jr 		z,Interface
		and 	$3F
		cp 		$20
		jr 		z,Interface
		xor 	$20
		add 	$20
		cp 		'A'
		jr 		c,_SEBNotAlpha
		cp 		'Z'+1
		jr 		nc,_SEBNotAlpha
		add 	$20
_SEBNotAlpha:
		ld 		(hl),a
		inc 	hl
		inc 	de
		jr 		_SEBCopy		

		.include 	"code.asm"
		.include 	"compiler.asm"
		.include 	"search.asm"
		.include 	"toint.asm"
	
