; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		code.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		15th October 2021
;		Purpose :	Miscellaneous words
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
; 		Copy the code following (length byte first) then pop to previous level.
;
; ***************************************************************************************

CopyFollowing:
	ex 		(sp),hl  				 		; old HL saved on stack, HL contains length pointer
	push 	bc 								; save BC
	ld 		b,(hl) 							; get count to copy
_CopyFollowing:
	inc 	hl 								; get next to copy
	ld 		a,(hl)
	call 	CompileByte 					; and compile it.
	djnz 	_CopyFollowing 					; copy that many bytes.	
	pop 	bc 								; restore BC, HL
	pop 	hl 
	ret 									; return to the previous level.

; ***************************************************************************************
;
; 							Compile call to following code
;
; ***************************************************************************************

CompileCallFollowing:
	ld 		a,$CD 							; CD is Z80 "CALL" 
	call 	CompileByte
	pop 	hl 								; get address to compile call to
	call 	CompileWord
	ret 									; return to the previous level.

; ***************************************************************************************
;
;									Compile HL to Code Space
;
; ***************************************************************************************

CompileWord:
	ex 		de,hl 							; DE contains value
	push 	hl 								; save HL
	ld 		hl,(CodeNextFree) 				; get code address
	ld 		(hl),e 							; write out
	inc 	hl 
	ld 		(hl),d
	inc 	hl
	ld 		(CodeNextFree),hl 				; update code address
	pop 	hl 								; restore HL, DE
	ex 		de,hl 							
	ret

; ***************************************************************************************
;
;									Compile A to Code Space
;
; ***************************************************************************************

CompileByte:
	push 	hl 								; save HL, get code address
	ld 		hl,(CodeNextFree)
	ld 		(hl),a  						; write out
	inc 	hl 								; bump & write back
	ld 		(CodeNextFree),hl
	pop 	hl 	
	ret
