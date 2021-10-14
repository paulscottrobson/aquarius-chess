; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		miscellany.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		14th October 2021
;		Purpose :	Miscellaneous words
;
; ***************************************************************************************
; ***************************************************************************************


@calls 	sys.stdHeaderRoutine
compileCallToSelf:
		jp 		__compileCallToSelf
@end
;
;		The header routine for normal code - compiles a call to the address immediately
;		following the 'call' to this routine.
;
__compileCallToSelf:
		ex 		(sp),hl 							; get the routine addr into HL, old HL on TOS.

		ld 		a,$CD 								; Z80 Call
		call 	FARCompileByte
		call 	FARCompileWord

		pop 	hl 									; restore HL and exit
		ret

; ***************************************************************************************

@calls 	sys.stdMacroRoutine
compileCopySelf:
		jp 		__compileCopySelf
@end

@calls 	sys.stdExecMacroRoutine
compileExecutableCopySelf:
		jp 		__compileExecutableCopySelf
@end

;
;		Macro code - compiles the code immediately following the call to this routine.
;		First byte is the length, subsequent is data.
;

__compileCopySelf: 									; different addresses to tell executable ones.
		nop
__compileExecutableCopySelf:
		ex 		(sp),hl 							; routine start into HL, old HL on TOS
		push 	bc 									; save BC
		ld 		b,(hl)								; get count
		inc 	hl
__copyMacroCode:
		ld 		a,(hl)								; do next byte
		call 	FARCompileByte
		inc 	hl
		djnz 	__copyMacroCode
		pop 	bc 									; restore and exit.
		pop 	hl
		ret


; ***************************************************************************************

@calls 	sys.variableRoutine
variableAddressCompiler:
		ld 		a,$EB 								; ex de,hl
		call 	FARCompileByte
		ld 		a,$21								; ld hl,xxxxx
		call 	FARCompileByte
		pop 	hl 									; var address
		call 	FARCompileWord
		ret
@end

; ***************************************************************************************

@copies 	break
		db 		$DD,$01
@end

