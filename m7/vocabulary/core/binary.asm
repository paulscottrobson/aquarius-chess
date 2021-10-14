; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		binary.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		5th January 2019
;		Purpose :	Binary operators (A ? B -> A)
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************

@word 	<
	ld 		a,h 								 	; check if signs different.
	xor 	d
	add 	a,a 									; CS if different
	jr 		nc,__less_samesign
	ld 		a,d 									; different. set CS to sign of B
	add 	a,a 									; if set (negative) B must be < A as A is +ve
	jr 		__less_returnc
__less_samesign:
	push 	de 										; save DE
	ex 		de,hl 									; -1 if B < A
	sbc 	hl,de 									; calculate B - A , hencs CS if < (Carry clear by add a,a)
	pop 	de 										; restore DE
__less_returnc:
	ld 		a,0 									; A 0
	sbc 	a,0 									; A $FF if CS.
	ld 		l,a 									; put in HL
	ld 		h,a
	ret
@end

; ***************************************************************************************

@word 	=
	ld 		a,h 									; H = H ^ D
	xor 	d
	ld 		h,a
	ld 		a,l 									; A = (L ^ E) | (H ^ D)
	xor 	e
	or 		h 										; if A == 0 they are the same.
	ld 		hl,$0000 								; return 0 if different
	ret 	nz
	dec 	hl 										; return -1
	ret
@end

; ***************************************************************************************

@word	- 					
	push 	de 										; save DE
	ex 		de,hl 									; HL = B, DE = A
	xor 	a  										; clear carry
	sbc 	hl,de 									; calculate B-A
	pop 	de 										; restore DE
	ret
@end

; ***************************************************************************************

@word 	*
	jp  	MULTMultiply16
@end

; ***************************************************************************************

@word	/
	push 	de
	call 	DIVDivideMod16
	ex 		de,hl
	pop 	de
	ret
@end

; ***************************************************************************************

@xmacro +
	add 	hl,de
@end

; ***************************************************************************************

@word	and
	ld 		a,h
	and 	d
	ld 		h,a
	ld 		a,l
	and 	e
	ld 		l,a
	ret
@end

; ***************************************************************************************

@word	mod
	push 	de
	call 	DIVDivideMod16
	pop 	de
	ret
@end

; ***************************************************************************************

@word	or
	ld 		a,h
	or 		d
	ld 		h,a
	ld 		a,l
	or 		e
	ld 		l,a
	ret
@end

; ***************************************************************************************

@word	xor
	ld 		a,h
	xor 	d
	ld 		h,a
	ld 		a,l
	xor 	e
	ld 		l,a
	ret
@end

