; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		miscellany.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		5th January 2019
;		Purpose :	Miscellaneous words
;
; ***************************************************************************************
; ***************************************************************************************

@word 	,
		jp 		FARCompileWord
@end

; ***************************************************************************************

@macro 	;
		ret
@end

; ***************************************************************************************

@word 	c,
		ld 		a,l
		jp 		FARCompileWord
@end

; ***************************************************************************************

@word 	copy
		ld 		a,b 								; exit if C = 0
		or 		c
		ret 	z

		push 	bc 									; BC count
		push 	de 									; DE target
		push 	hl 									; HL source

		xor 	a 									; Clear C
		sbc 	hl,de 								; check overlap ?
		jr 		nc,__copy_gt_count 					; if source after target
		add 	hl,de 								; undo subtract

		add 	hl,bc 								; add count to HL + DE
		ex 		de,hl
		add 	hl,bc
		ex 		de,hl
		dec 	de 									; dec them, so now at the last byte to copy
		dec 	hl
		lddr 										; do it backwards
		jr 		__copy_exit

__copy_gt_count:
		add 	hl,de 								; undo subtract
		ldir										; do the copy
__copy_exit:
		pop 	hl 									; restore registers
		pop 	de
		pop 	bc
		ret
@end

; ***************************************************************************************

@word 	fill
		ld 		a,b 								; exit if C = 0
		or 		c
		ret 	z

		push 	bc 									; BC count
		push 	de 									; DE target, L byte
__fill_loop:
		ld 		a,l 								; copy a byte
		ld 		(de),a
		inc 	de 									; bump pointer
		dec 	bc 									; dec counter and loop
		ld 		a,b
		or 		c
		jr 		nz,__fill_loop
		pop 	de 									; restore
		pop 	bc
		ret
@end

; ***************************************************************************************

@word 	halt
__halt_loop:
		di
		halt 	
		jr 		__halt_loop
@end

; ***************************************************************************************

@word 	sys.stdHeaderRoutine
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

@word 	sys.stdMacroRoutine
compileCopySelf:
		jp 		__compileCopySelf
@end

@word 	sys.stdExecMacroRoutine
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

@word 	sys.variableRoutine
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

@macro 	break
		db 		$DD,$01
@end

