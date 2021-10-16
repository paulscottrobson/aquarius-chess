; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		find.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		16th October 2021
;		Purpose :	Search dictionary
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
; 		Search dictionary for word at HL, which is internal format (2+6 ended with 
;		(2+space or $00). On exit HL points to the type byte or $0000 if not found.
;
; ***************************************************************************************

SearchDictionary:
		push 	bc
		push 	de
		ex 		de,hl 						; put search string address in DE.
		ld 		hl,(DictionaryBase) 		; HL points to dictionary base.
		;
		; 		Compare entry at HL vs word at DE
		;
_SearchLoop:
		ld 		b,h 						; copy current being searched to BC
		ld 		c,l 								
		ld 		a,(hl) 						; get the type byte.
		or 	 	a 							; if zero, then fail as we've reached dictionary end.
		jr 		z,_SDFail
		;
		inc  	hl 							; point to the first character
		inc 	hl 							; e.g. skip type byte and call address.
		inc 	hl
		push 	de 							; save search string address on stack.
		;
		; 		Compare string at HL vs String at DE
		;
_SearchCompare:
		ld 		a,(de) 						; calculate xor of two characters
		xor 	(hl) 						; as we're only interested in lower 6 bits for compare
		and 	$3F 						; check lower 6 bits only.
		jr 		nz,_SearchNext 				; different, go to next word.
		ld 		a,(hl) 						; get dictionary byte successfully matched.
		inc 	de 							; advance to next.
		inc 	hl 		
		add 	a,a 						; is bit 7 in the last match, indicating the last character of the word in the dictionary ?
		jr 		nc,_SearchCompare 			; no, keep comparing
		;
		; 		Found the end of the word in the dictionary, HL points to the byte following, DE the character following.
		;	 	We need to check it's the end of the word in the search text.
		;
		ld 		a,(de) 						; get the next character in the search word.
		pop 	de 							; having got the character, restore DE to original value.
		or 		a 							; is it $00 or xx10000 (any colour space)
		jr 		z,_SDSucceed 				; if zero, we've found the word, end of buffer
		and 	$3F 
		cp 		$20
		jr 		nz,_SearchLoop 				; no it wasn't any Space so go round again. HL points to the next type byte already.
_SDSucceed: 
		ld 		h,b 						; restore value saved in BC to HL, the type byte address of the found word.
		ld 		l,c  						; at the start, e.g. the address of the type byte.
		jr 		_SDExit
		;
		; 		Names did not match. HL still points into the word.
		;
_SearchNext:
		ld 		a,(hl) 						; get and bump in dictionary
		inc 	hl
		add 	a,a 						; looking for the bit 7 set indicating the end of the word
		jr 		nc,_SearchNext  			
		pop 	de 							; restore DE, the address of the input word
		jr 		_SearchLoop 				; and try the next dictionary word.
;
_SDFail:									; not found, return zero
		ld 		hl,$0000 					
_SDExit:
		pop 	de
		pop 	bc		
		ret		


