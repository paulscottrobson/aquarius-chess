; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		toint.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		16th October 2021
;		Purpose :	Convert a word to an integer.
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
;		Convert word to integer. Can be decimal $hexadecimal and prefixed with '-'
;		Result in HL, DE is non-zero if successful.
;
; ***************************************************************************************

StringToInteger:
		ld 		a,(hl) 						; check for - x
		and 	$3F
		cp 		'-'
		jr 		nz,_STOInt
		inc 	hl 							; skip the - sign. 
		call 	_STOInt 					; try to convert to integer

		ld 		a,h 						; negate the result.
		cpl 
		ld 		h,a
		ld 		a,l
		cpl
		ld 		l,a
		inc 	hl
		ret

_STOInt:push 	ix 							; save IX
		

		push 	hl 							; copy word address to IX
		pop 	ix		
		ld 		bc,10*256 					; base in B, count in C
		ld 		hl,0 						; result in HL.
		;
		ld 		a,(ix+0) 					; is first character a '$'
		and 	$3F
		cp 		'$'
		jr 		nz,_STONotHex 
		;
		ld 		b,16 						; now Base 16.
		inc 	ix 							; skip over the '$'
_STONotHex:
		;
		; 		Main processing loop.
		;		
_STOLoop:
		ld 		a,(ix+0) 					; get character
		inc 	ix
		or 		a  							; check for $00 or Coloured space
		jr 		z,_STOEndWord 					
		and 	$3F
		cp 		$20
		jr 		z,_STOEndWord
		;
		cp 		'9'+1 						; if > 9 then fail
		jr 		nc,_STOFail
		cp 		'0'
		jr 		nc,_STOOkay
		cp 		6+1 						; if > F then fail
		jr 		nc,_STOFail
		or 		a
		jr 		z,_STOFail 					; $00 is a fail too.
		add 	9 							; maps A ($01) to ($0A) etc.
_STOOkay:
		inc 	c 							; increment successful char count		
		and 	$0F 						; make digit in range 0..15
		cp 		b 							; fail if >= the base
		jr 		nc,_STOFail
		;
		add 	hl,hl 						; HL = 2 * HL
		ld 		e,l 						; DE = 2 * HL
		ld 		d,h		
		add 	hl,hl 						; HL = 4 * HL
		add 	hl,hl 						; HL = 8 * HL
		bit 	4,b 						; is base 16 ?
		jr 		z,_STONotHexMult
		ld 		e,l 						; if base 16 HL = DE = 8 * HL
		ld 		d,h
_STONotHexMult:
		add 	hl,de 						; so HL = HL * 10 or * 16 depending on B
		ld 		e,a 						; put digit in DE and add
		ld 		d,0
		add 	hl,de
		jr 		_STOLoop
;
_STOEndWord:
		ld 		e,c 						; E is 0 if no chars, e.g. fail or #0 if chars consumed
		ld 		d,c 						; D the same
		jr 		_STOExit 					; and exit

_STOFail:	 								; can't do it, return DE = HL = 0	
		ld 		de,0
		ld 		hl,0
_STOExit:		
		pop 	ix 							; restore IX and exit
		ret

		