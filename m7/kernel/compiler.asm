; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		compiler.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		16th October 2021
;		Purpose :	Compile stream defining executing or compiling words 
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
; 	Compile stream at HL, executing, compiling or defining words according to their 
; 	colour. This is not re-entrant, as it exits to the warm start unless it goes to 
; 	compile something else.
;
; ***************************************************************************************

CompileStream:
		ld 		a,(hl) 						; get next character
		or 		a 							; if zero, warm start as end of stream
		jp 		z,WarmStart
		inc 	hl 							; increment in case it is space
		and 	$3F 						; check it is a coloured space.
		cp 		$20
		jr 		z,CompileStream 			; if so go back
		dec 	hl 							; undo the get, so points to the non space non zero byte.
		call 	CompileOne 					; compile word at HL.
		;
_CSNext:		
		ld 		a,(hl) 						; advance forward to next word
		or 		a 							; if found $00 end of stream go back to CompileStream
		jr 		z,CompileStream
		inc 	hl
		and 	#$3F 						; check for colour space
		cp 		$20
		jr 		nz,_CSNext
		jr 		CompileStream 				; once found, try the next word.

; ***************************************************************************************
;
; 						  Compile/Execute/Define word at HL.
;
; ***************************************************************************************

CompileOne:
		ld 		a,(hl) 						; get the word's colour.
		and 	$C0
		ret  	z 							; exit immediately if it's a comment word.
		push 	hl 							; save HL on stack

		cp 		$C0 						; $40 and $80 , compile or execute, handled together
		jr 		nz,_COExecuteCompile
		;
		; 		Create a new definition using the word at HL.
		;
		ld 		b,$FF 						; we write it out backwards so go forward counting characters. We count the space so -1 here.
_CDFindEnd:
		inc 	b 							; bump count
		ld 		a,(hl) 						; get character		
		inc 	hl
		or 		a
		jr 		z,_CDFoundEnd		 		; if zero, we're at the end
		and 	$3F
		cp 		$20
		jr 		nz,_CDFindEnd
_CDFoundEnd:
		;
		; 		HL points one after the word end seperator, B is the count. C is the OR value for copying, which is only set 
		; 		first time to $80
		ld 		c,$80 						; the copy OR value
		dec 	hl 							; undo the get after getting the space.
_CDCopyDictionary:
		dec 	hl 							; get previous character. we are writing out backwards as we go down
		ld 		a,(hl)
		and 	$3F 						; colour dropped. (should be red)
		or 		c  							; OR C in, first time $80
		ld 		c,0 						; and next times it's only $00		
		call	CompileWriteDictionary 
		djnz 	_CDCopyDictionary 			; write out the whole word.
		;
		; 		Now create the rest of the record, the code address then type byte.
		;
		ld 		a,(CodeNextFree+1) 			; write out code MSB then LSB
		call	CompileWriteDictionary 
		ld 		a,(CodeNextFree)
		call	CompileWriteDictionary 
		ld 		a,$80 						; then the default type byte
		call	CompileWriteDictionary 
		pop 	hl 							; restore HL and exit.
		ret
;
; 		Compile or execute the word at HL.
;
_COExecuteCompile:
		halt


; ***************************************************************************************
;
; 						Write dictionary word out backwards
;
; ***************************************************************************************

CompileWriteDictionary:
		push 	hl
		ld 		hl,(DictionaryBase)
		dec 	hl
		ld 		(hl),a
		ld 		(DictionaryBase),hl
		pop 	hl
		ret
