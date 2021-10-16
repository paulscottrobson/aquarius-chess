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

		ld 		a,$CD 						; compile CALL CompileCallFollowing into code, the default action.
		call 	CompileByte 				; e.g. the word compiles a call to whatever follows it.
		ld 		hl,CompileCallFollowing
		call 	CompileWord

_COPopHLExit:
		pop 	hl 							; restore HL and exit.
		ret
;
; 		Compile or execute the word at HL.
;
_COExecuteCompile:
		push 	hl 							; save word text address
		call 	SearchDictionary 			; try to find it in the dictionary
		ld 		a,h 						; was it found ?
		or 		l
		jr 		z,_CECUnknown
		;
		; 		Word in the dictionary.
		;
		pop 	de 							; get word text back in DE
		bit 	0,(hl) 						; is this execute only ?
		jr 		z,_CECNotCompileOnly
		ld 		a,(de)  					; what are we doing with it ?
		and 	$C0  						; get colour
		cp 		$80  						; if execute ?
		jp 		z,WordIsCompileOnly 		; then we have an error.
_CECNotCompileOnly:		
		ld 		a,(de) 						; get the word colour and save on the stack
		and 	$C0
		push	af

		ld 		de,(CodeNextFree) 			; save the current code position on the stack.
		push 	de 

		call 	_COCallRoutine 				; call the routine to compile what it does.
		pop 	hl 							; restore code position at start to HL.
		pop 	af 							; restore word colour.

		cp 	 	$80 						; if not execute
		jr 	 	nz,_COPopHLExit 			; then return, as we've done the compile

		ld 		a,$C9 						; this is the Z80 RET which we need to compile after the code
		call 	CompileByte
		ld 		(CodeNextFree),hl 			; reset the code pointer, as we don't want to keep this executed word.

		ld 		de,_CEXContinue 			; go here on return
		push 	de
		push 	hl 							; go here, the newly compiled code, first, this is for the RET below

		ld 		hl,(RegA) 					; load registers
		ld 		de,(RegB) 					
		ld 		bc,(RegC) 					

		ret 								; execute the code, as we pushed HL - not actually returning :)

_CEXContinue:
		ld 		(RegA),hl 					; save the registers
		ld 		(RegB),de
		ld 		(RegC),bc

		jr 		_COPopHLExit 				; pop HL and exit
		;
		; 		Call the routine to compile the code.
		;
_COCallRoutine:
		inc 	hl 							; call address into DE
		ld 		e,(hl)
		inc 	hl
		ld 		d,(hl)
		ex 		de,hl 						; and go there
_COCallHL:		
		jp 		(hl)
		;
		; 		Word not in the dictionary. Could be a constant or a string 
		;
_CECUnknown:		
		pop 	hl 							; restore word address.
		ld 		a,(hl) 						; look at the first character
		and 	$3F
		cp 		$22 						; is it a quote, indicating a string.
		jr 		z,_CSTRProcess 
		;
		; 		Now it must be a constant
		;
		ld 		a,(hl) 						; push the colour on the stack
		and 	$C0
		push 	af
		call 	StringToInteger 			; convert a word to a valid integer.
		ld 		a,d 						; DE = 0 if fail.
		or 		e
		jp 		z,UnknownWord 
		;
		pop 	af  
		cp 		$80 						; if execute, do execute constant.
		jr 		z,_CECExecuteConstant
		;
		; 		Compile a constant inline.
		;
_CECCompileConstant:		
		ld 		a,$EB 						; compile EX DE,HL
		call 	CompileByte
		ld 		a,$21 						; LD HL,xxxxx
		call 	CompileByte
		call 	CompileWord 				; compile the number to load
		halt
		jr 		_COPopHLExit 				; and exit
		;
		; 		Do the equivalent of executing a constant.
		;
_CECExecuteConstant:
		ld 		de,(RegA) 					; A -> B
		ld 		(RegB),de
		ld 		(RegA),hl 					; constant -> HL
		jp 		_COPopHLExit 				; and exit
		;
		; 		HL points to a string, prefixed by a ". Note, this is transient in execute mode.
		;
_CSTRProcess:
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
