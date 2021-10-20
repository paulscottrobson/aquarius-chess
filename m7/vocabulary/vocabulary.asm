; --------------------------------------
;             <
; --------------------------------------
word_1000:
	call	CompileCallFollowing
 ld   a,h           ; check if signs different.
 xor  d
 add  a,a          ; CS if different
 jr   nc,__less_samesign
 ld   a,d          ; different. set CS to sign of B
 add  a,a          ; if set (negative) B must be < A as A is +ve
 jr   __less_returnc
__less_samesign:
 push  de           ; save DE
 ex   de,hl          ; -1 if B < A
 sbc  hl,de          ; calculate B - A , hencs CS if < (Carry clear by add a,a)
 pop  de           ; restore DE
__less_returnc:
 ld   a,0          ; A 0
 sbc  a,0          ; A $FF if CS.
 ld   l,a          ; put in HL
 ld   h,a
 ret
; --------------------------------------
;             =
; --------------------------------------
word_1001:
	call	CompileCallFollowing
 ld   a,h          ; H = H ^ D
 xor  d
 ld   h,a
 ld   a,l          ; A = (L ^ E) | (H ^ D)
 xor  e
 or   h           ; if A == 0 they are the same.
 ld   hl,$0000         ; return 0 if different
 ret  nz
 dec  hl           ; return -1
 ret
; --------------------------------------
;             -
; --------------------------------------
word_1002:
	call	CompileCallFollowing
 push  de           ; save DE
 ex   de,hl          ; HL = B, DE = A
 xor  a            ; clear carry
 sbc  hl,de          ; calculate B-A
 pop  de           ; restore DE
 ret
; --------------------------------------
;             +
; --------------------------------------
word_1003:
	call	CopyFollowing
	.db	endcopy_1003 - $ - 1
 add  hl,de
endcopy_1003:
; --------------------------------------
;             AND
; --------------------------------------
word_1004:
	call	CompileCallFollowing
 ld   a,h
 and  d
 ld   h,a
 ld   a,l
 and  e
 ld   l,a
 ret
; --------------------------------------
;             OR
; --------------------------------------
word_1005:
	call	CompileCallFollowing
 ld   a,h
 or   d
 ld   h,a
 ld   a,l
 or   e
 ld   l,a
 ret
; --------------------------------------
;             XOR
; --------------------------------------
word_1006:
	call	CompileCallFollowing
 ld   a,h
 xor  d
 ld   h,a
 ld   a,l
 xor  e
 ld   l,a
 ret
; --------------------------------------
;             /
; --------------------------------------
word_1007:
	call	CompileCallFollowing
 push  de
 call  DIVDivideMod16
 ex   de,hl
 pop  de
 ret
; --------------------------------------
;             MOD
; --------------------------------------
word_1008:
	call	CompileCallFollowing
 push  de
 call  DIVDivideMod16
 pop  de
 ret
; --------------------------------------
;             !
; --------------------------------------
word_1009:
	call	CopyFollowing
	.db	endcopy_1009 - $ - 1
  ld   (hl),e
  inc  hl
  ld   (hl),d
  dec  hl
endcopy_1009:
; --------------------------------------
;             @
; --------------------------------------
word_1010:
	call	CopyFollowing
	.db	endcopy_1010 - $ - 1
  ld   a,(hl)
  inc  hl
  ld  h,(hl)
  ld  l,a
endcopy_1010:
; --------------------------------------
;             +!
; --------------------------------------
word_1011:
	call	CompileCallFollowing
  ld   a,(hl)
  add  a,e
  ld   (hl),a
  inc  hl
  ld   a,(hl)
  adc  a,d
  ld   (hl),a
  dec  hl
  ret
; --------------------------------------
;             C!
; --------------------------------------
word_1012:
	call	CopyFollowing
	.db	endcopy_1012 - $ - 1
  ld   (hl),e
endcopy_1012:
; --------------------------------------
;             C@
; --------------------------------------
word_1013:
	call	CopyFollowing
	.db	endcopy_1013 - $ - 1
  ld   l,(hl)
  ld   h,0
endcopy_1013:
; --------------------------------------
;             P@
; --------------------------------------
word_1014:
	call	CompileCallFollowing
  push  bc
  ld  b,h
  ld   c,l
  in   l,(c)
  ld   h,0
  pop  bc
  ret
; --------------------------------------
;             P!
; --------------------------------------
word_1015:
	call	CompileCallFollowing
  push  bc
  push  hl
  ld   a,e
  ld  b,h
  ld   c,l
  out  (c),a
  pop  hl
  pop  bc
  ret
; --------------------------------------
;             ,
; --------------------------------------
word_1016:
	call	CompileCallFollowing
  jp   CompileWord
; --------------------------------------
;             ;
; --------------------------------------
word_1017:
  ld   a,$C9         ; compile a RET
  call  CompileByte
  ; TODO: Check close to $E000,  so we can skip the ROM header.
  ret
; --------------------------------------
;             C,
; --------------------------------------
word_1018:
	call	CompileCallFollowing
  ld   a,l
  jp   CompileByte
; --------------------------------------
;             COPY
; --------------------------------------
word_1019:
	call	CompileCallFollowing
  ld   a,b         ; exit if C = 0
  or   c
  ret  z

  push  bc          ; BC count
  push  de          ; DE target
  push  hl          ; HL source

  xor  a          ; Clear C
  sbc  hl,de         ; check overlap ?
  jr   nc,__copy_gt_count      ; if source after target
  add  hl,de         ; undo subtract

  add  hl,bc         ; add count to HL + DE
  ex   de,hl
  add  hl,bc
  ex   de,hl
  dec  de          ; dec them, so now at the last byte to copy
  dec  hl
  lddr           ; do it backwards
  jr   __copy_exit

__copy_gt_count:
  add  hl,de         ; undo subtract
  ldir          ; do the copy
__copy_exit:
  pop  hl          ; restore registers
  pop  de
  pop  bc
  ret
; --------------------------------------
;             FILL
; --------------------------------------
word_1020:
	call	CompileCallFollowing
  ld   a,b         ; exit if C = 0
  or   c
  ret  z

  push  bc          ; BC count
  push  de          ; DE target, L byte
__fill_loop:
  ld   a,l         ; copy a byte
  ld   (de),a
  inc  de          ; bump pointer
  dec  bc          ; dec counter and loop
  ld   a,b
  or   c
  jr   nz,__fill_loop
  pop  de          ; restore
  pop  bc
  ret
; --------------------------------------
;             HALT
; --------------------------------------
word_1021:
	call	CompileCallFollowing
__halt_loop:
  di
  halt
  jr   __halt_loop
; --------------------------------------
;             BREAK
; --------------------------------------
word_1022:
	call	CopyFollowing
	.db	endcopy_1022 - $ - 1
  db   $76
endcopy_1022:
; --------------------------------------
;             *
; --------------------------------------
word_1023:
	call	CompileCallFollowing
 jp   MULTMultiply16
; --------------------------------------
;             SWAP
; --------------------------------------
word_1024:
	call	CopyFollowing
	.db	endcopy_1024 - $ - 1
  ex   de,hl
endcopy_1024:
; --------------------------------------
;             A>B
; --------------------------------------
word_1025:
	call	CopyFollowing
	.db	endcopy_1025 - $ - 1
  ld   d,h
  ld   e,l
endcopy_1025:
; --------------------------------------
;             A>C
; --------------------------------------
word_1026:
	call	CopyFollowing
	.db	endcopy_1026 - $ - 1
  ld   b,h
  ld   c,l
endcopy_1026:
; --------------------------------------
;             B>A
; --------------------------------------
word_1027:
	call	CopyFollowing
	.db	endcopy_1027 - $ - 1
  ld   h,d
  ld   l,e
endcopy_1027:
; --------------------------------------
;             B>C
; --------------------------------------
word_1028:
	call	CopyFollowing
	.db	endcopy_1028 - $ - 1
  ld   b,d
  ld   c,e
endcopy_1028:
; --------------------------------------
;             C>A
; --------------------------------------
word_1029:
	call	CopyFollowing
	.db	endcopy_1029 - $ - 1
  ld   h,b
  ld   l,c
endcopy_1029:
; --------------------------------------
;             C>B
; --------------------------------------
word_1030:
	call	CopyFollowing
	.db	endcopy_1030 - $ - 1
  ld   d,b
  ld   e,c
endcopy_1030:
; --------------------------------------
;             PUSH
; --------------------------------------
word_1031:
	call	CopyFollowing
	.db	endcopy_1031 - $ - 1
 push  hl
endcopy_1031:
; --------------------------------------
;             POP
; --------------------------------------
word_1032:
	call	CopyFollowing
	.db	endcopy_1032 - $ - 1
 ex   de,hl
 pop  hl
endcopy_1032:
; --------------------------------------
;             A>R
; --------------------------------------
word_1033:
	call	CopyFollowing
	.db	endcopy_1033 - $ - 1
 push  hl
endcopy_1033:
; --------------------------------------
;             R>A
; --------------------------------------
word_1034:
	call	CopyFollowing
	.db	endcopy_1034 - $ - 1
 pop  hl
endcopy_1034:
; --------------------------------------
;             B>R
; --------------------------------------
word_1035:
	call	CopyFollowing
	.db	endcopy_1035 - $ - 1
 push  de
endcopy_1035:
; --------------------------------------
;             R>B
; --------------------------------------
word_1036:
	call	CopyFollowing
	.db	endcopy_1036 - $ - 1
 pop  de
endcopy_1036:
; --------------------------------------
;             C>R
; --------------------------------------
word_1037:
	call	CopyFollowing
	.db	endcopy_1037 - $ - 1
 push  bc
endcopy_1037:
; --------------------------------------
;             R>C
; --------------------------------------
word_1038:
	call	CopyFollowing
	.db	endcopy_1038 - $ - 1
 pop  bc
endcopy_1038:
; --------------------------------------
;             AB>R
; --------------------------------------
word_1039:
	call	CopyFollowing
	.db	endcopy_1039 - $ - 1
 push  de
 push  hl
endcopy_1039:
; --------------------------------------
;             R>AB
; --------------------------------------
word_1040:
	call	CopyFollowing
	.db	endcopy_1040 - $ - 1
 pop  hl
 pop  de
endcopy_1040:
; --------------------------------------
;             ABC>R
; --------------------------------------
word_1041:
	call	CopyFollowing
	.db	endcopy_1041 - $ - 1
 push  bc
 push  de
 push  hl
endcopy_1041:
; --------------------------------------
;             R>ABC
; --------------------------------------
word_1042:
	call	CopyFollowing
	.db	endcopy_1042 - $ - 1
 pop  hl
 pop  de
 pop  bc
endcopy_1042:
; --------------------------------------
;             H
; --------------------------------------
word_1043:
	call	CopyFollowing
	.db	endcopy_1043 - $ - 1
  ex  de,hl
  ld  hl,CodeNextFree
endcopy_1043:
; --------------------------------------
;             $SYSTEM
; --------------------------------------
word_1044:
	call	CopyFollowing
	.db	endcopy_1044 - $ - 1
  ex  de,hl
  ld  hl,InformationBlock
endcopy_1044:
; --------------------------------------
;             $DICTIONARY
; --------------------------------------
word_1045:
	call	CopyFollowing
	.db	endcopy_1045 - $ - 1
  ex  de,hl
  ld  hl,(DictionaryBase)
endcopy_1045:
; --------------------------------------
;             WARM.START
; --------------------------------------
word_1046:
	call	CompileCallFollowing
  jp   WarmStart
; --------------------------------------
;             REPORT.ERROR
; --------------------------------------
word_1047:
	call	CompileCallFollowing
  jp   Interface
; --------------------------------------
;             $COMPILER
; --------------------------------------
word_1048:
	call	CompileCallFollowing
  jp   CompileStream
; --------------------------------------
;             CONSTANT
; --------------------------------------
word_1049:
  ld   hl,(CodeNextFree)    ; fix up definition to remove call address.
  dec  hl
  dec  hl
  ld   (CodeNextFree),hl    ; keeping the CALL opcode.
  ;
  ld   hl,ConstantHandler    ; make it CALL ConstantHandler
  call  CompileWord
  ld   hl,(RegA)     ; and put the word in after.
  call  CompileWord
  ret
; --------------------------------------
;             VARIABLE
; --------------------------------------
word_1050:
  ld   hl,(CodeNextFree)    ; fix up definition to remove call address.
  dec  hl
  dec  hl
  ld   (CodeNextFree),hl    ; keeping the CALL opcode.
  ;
  ld   hl,VariableHandler    ; make it CALL VariableHandler
  call  CompileWord
  ld   hl,$0000     ; initialise to zero.
  call  CompileWord
  ret
; --------------------------------------
;             DATA
; --------------------------------------
word_1051:
  ld   hl,(CodeNextFree)    ; fix up definition to remove call address.
  dec  hl
  dec  hl
  ld   (CodeNextFree),hl    ; keeping the CALL opcode.
  ;
  ld   hl,VariableHandler    ; make it CALL VariableHandler
  call  CompileWord
  ret
; --------------------------------------
;             ARRAY
; --------------------------------------
word_1052:
  ld   hl,(CodeNextFree)    ; fix up definition to remove call address.
  dec  hl
  dec  hl
  ld   (CodeNextFree),hl    ; keeping the CALL opcode.
  ;
  ld   hl,VariableHandler    ; make it CALL VariableHandler
  call  CompileWord

  ld   hl,(RegA)     ; initialise to zero.
_MakeArray:
  ld   a,h
  or   l
  ret  z
  dec  hl
  xor  a
  call  CompileByte
  jr   _MakeArray
  ret
; --------------------------------------
;             ADDRESS.OF
; --------------------------------------
word_1053:
  push  de
  push  hl
  ld   hl,(CodeNextFree)    ; get previous code address
  dec  hl
  ld   d,(hl)
  dec  hl
  ld   e,(hl)
  dec  hl
  ld   (CodeNextFree),hl    ; we've removed the word, address is in DE
  ex   de,hl
  call  CompileLoadConstant
  pop  hl
  pop  de
  ret
; --------------------------------------
;             !!
; --------------------------------------
word_1054:
  ld   hl,(CodeNextFree)    ; we save one byte.
  dec  hl
  ld   (CodeNextFree),hl
  ;
  ld   b,(hl)
  dec  hl
  ld   c,(hl)
  ld   (hl),b
  dec  hl
  ld   (hl),c
  dec  hl
  ld   (hl),$22
  ret
; --------------------------------------
;             @@
; --------------------------------------
word_1055:
  ld   hl,(CodeNextFree)    ; we save one byte.
  ;
  dec  hl
  dec  hl
  dec  hl
  ld   (hl),$2A
  ret
; --------------------------------------
;             ---
; --------------------------------------
word_1056:
	call	CopyFollowing
	.db	endcopy_1056 - $ - 1
  dec  hl
  dec  hl
endcopy_1056:
; --------------------------------------
;             --
; --------------------------------------
word_1057:
	call	CopyFollowing
	.db	endcopy_1057 - $ - 1
  dec  hl
endcopy_1057:
; --------------------------------------
;             ++
; --------------------------------------
word_1058:
	call	CopyFollowing
	.db	endcopy_1058 - $ - 1
  inc  hl
endcopy_1058:
; --------------------------------------
;             +++
; --------------------------------------
word_1059:
	call	CopyFollowing
	.db	endcopy_1059 - $ - 1
  inc  hl
  inc  hl
endcopy_1059:
; --------------------------------------
;             0-
; --------------------------------------
word_1060:
	call	CompileCallFollowing
__negate:
  ld   a,h
  cpl
  ld   h,a
  ld   a,l
  cpl
  ld   l,a
  inc  hl
  ret
; --------------------------------------
;             0<
; --------------------------------------
word_1061:
	call	CompileCallFollowing
  bit  7,h
  ld   hl,$0000
  ret  z
  dec  hl
  ret
; --------------------------------------
;             0=
; --------------------------------------
word_1062:
	call	CompileCallFollowing
  ld   a,h
  or   l
  ld   hl,$0000
  ret  nz
  dec  hl
  ret
; --------------------------------------
;             2*
; --------------------------------------
word_1063:
	call	CopyFollowing
	.db	endcopy_1063 - $ - 1
  add  hl,hl
endcopy_1063:
; --------------------------------------
;             4*
; --------------------------------------
word_1064:
	call	CopyFollowing
	.db	endcopy_1064 - $ - 1
  add  hl,hl
  add  hl,hl
endcopy_1064:
; --------------------------------------
;             8*
; --------------------------------------
word_1065:
	call	CopyFollowing
	.db	endcopy_1065 - $ - 1
  add  hl,hl
  add  hl,hl
  add  hl,hl
endcopy_1065:
; --------------------------------------
;             16*
; --------------------------------------
word_1066:
	call	CopyFollowing
	.db	endcopy_1066 - $ - 1
  add  hl,hl
  add  hl,hl
  add  hl,hl
  add  hl,hl
endcopy_1066:
; --------------------------------------
;             2/
; --------------------------------------
word_1067:
	call	CopyFollowing
	.db	endcopy_1067 - $ - 1
  sra  h
  rr   l
endcopy_1067:
; --------------------------------------
;             4/
; --------------------------------------
word_1068:
	call	CopyFollowing
	.db	endcopy_1068 - $ - 1
  sra  h
  rr   l
  sra  h
  rr   l
endcopy_1068:
; --------------------------------------
;             ABS
; --------------------------------------
word_1069:
	call	CompileCallFollowing
  bit  7,h
  ret  z
  jp   __negate
; --------------------------------------
;             BSWAP
; --------------------------------------
word_1070:
	call	CopyFollowing
	.db	endcopy_1070 - $ - 1
  ld   a,l
  ld   l,h
  ld   h,a
endcopy_1070:
; --------------------------------------
;             NOT
; --------------------------------------
word_1071:
	call	CompileCallFollowing
  ld   a,h
  cpl
  ld   h,a
  ld   a,l
  cpl
  ld   l,a
  ret
; --------------------------------------
;             STRLEN
; --------------------------------------
word_1072:
	call	CompileCallFollowing
  push  de
  ex   de,hl
  ld   hl,0
_SLNLoop:
  ld   a,(de)
  or   a
  jr   z,_SLNExit
  inc  de
  inc  hl
  jr   _SLNLoop
_SLNExit:
  pop  de
  ret
; --------------------------------------
;             RANDOM
; --------------------------------------
word_1073:
	call	CompileCallFollowing
 ex   de,hl
 push  bc
    ld   hl,(seed1)
    ld   b,h
    ld   c,l
    add  hl,hl
    add  hl,hl
    inc  l
    add  hl,bc
    ld   (seed1),hl
    ld   hl,(seed2)
    add  hl,hl
    sbc  a,a
    and  %00101101
    xor  l
    ld   l,a
    ld   (seed2),hl
    add  hl,bc
    pop  bc
    ret
; --------------------------------------
;             IM.DRAW
; --------------------------------------
word_1074:
	call	CompileCallFollowing
  push  bc
  push  de
  push  hl

  ld   h,e
  ld   l,l

  ld   e,c
  ld   d,b

  ld   bc,$0000

  call  ImageDraw
  pop  hl
  pop  de
  pop  bc
  ret
; --------------------------------------
;             IM.COLOUR
; --------------------------------------
word_1075:
	call	CompileCallFollowing
  ld    a,l
  ld   (imageDefaultColour),a
  ret
; --------------------------------------
;             SG.DRAW
; --------------------------------------
word_1076:
	call	CompileCallFollowing
  push  bc
  push  de
  push  hl


  ld   c,(hl)    ; count in BC
  inc  hl
  ld   b,(hl)
  inc  hl

_SGDLoop:
  call  CopySpriteData
  call  DrawOneSprite
  inc  hl
  inc  hl
  dec  bc
  ld   a,b
  or   c
  jr   nz,_SGDLoop

  pop  hl
  pop  de
  pop  bc
  ret
; --------------------------------------
;             SG.ERASE
; --------------------------------------
word_1077:
	call	CompileCallFollowing
  push  bc
  push  de
  push  hl

  ld   a,(imageDefaultColour)
  push  af     ; save sprite default colour
  xor  a      ; zero it, just in case we are restoring $00.
  ld   (imageDefaultColour),a

  ld   c,(hl)    ; count in BC
  inc  hl
  ld   b,(hl)
  dec  hl

  add  hl,bc    ; advance to last.
  add  hl,bc
_SEDLoop:
  call  EraseOneSprite
  dec  hl
  dec  hl
  dec  bc
  ld   a,b
  or   c
  jr   nz,_SEDLoop

  pop  af     ; restore default colour
  ld   (imageDefaultColour),a

  pop  hl
  pop  de
  pop  bc
  ret



DIVDivideMod16:
 push  bc
 ld   b,d     ; DE
 ld   c,e
 ex   de,hl
 ld   hl,0
 ld   a,b
 ld   b,8
Div16_Loop1:
 rla
 adc  hl,hl
 sbc  hl,de
 jr   nc,Div16_NoAdd1
 add  hl,de
Div16_NoAdd1:
 djnz  Div16_Loop1
 rla
 cpl
 ld   b,a
 ld   a,c
 ld   c,b
 ld   b,8
Div16_Loop2:
 rla
 adc  hl,hl
 sbc  hl,de
 jr   nc,Div16_NoAdd2
 add  hl,de
Div16_NoAdd2:
 djnz  Div16_Loop2
 rla
 cpl
 ld   d,c
 ld   e,a
 pop  bc
 ret
MULTMultiply16:
  push  bc
  push  de
  ld   b,h        ; get multipliers in DE/BC
  ld   c,l
  ld   hl,0        ; zero total
__Core__Mult_Loop:
  bit  0,c        ; lsb of shifter is non-zero
  jr   z,__Core__Mult_Shift
  add  hl,de        ; add adder to total
__Core__Mult_Shift:
  srl  b         ; shift BC right.
  rr   c
  ex   de,hl        ; shift DE left
  add  hl,hl
  ex   de,hl
  ld   a,b        ; loop back if BC is nonzero
  or   c
  jr   nz,__Core__Mult_Loop
  pop  de
  pop  bc
  ret
ConstantHandler:
  ld   a,0xEB       ; compile ex de,hl
  call  CompileByte
  ld   a,0x21       ; compile ld hl,
  call  CompileByte
  pop  hl        ; address of word to compile
  ld   a,(hl)
  inc  hl
  ld   h,(hl)
  ld   l,a
  call  CompileWord     ; compile that word.
  ret


VariableHandler:
  ld   a,0xEB       ; compile ex de,hl
  call  CompileByte
  ld   a,0x21       ; compile ld hl,
  call  CompileByte
  pop  hl        ; address of word to compile
  call  CompileWord     ; compile that word.
  ret


FixAccessCodeWrite:
  ld   a,0x2A       ; LD HL,(xxxx)
  jr   nc,_FACIsRead     ; use Carry to decide what to update
  ld   a,0x22
_FACIsRead:
  ;
  ld   hl,(CodeNextFree)    ; we save one byte.
  dec  hl
  ld   (CodeNextFree),hl
  ;
  ld   b,(hl)
  dec  hl
  ld   c,(hl)
  ld   (hl),b
  dec  hl
  ld   (hl),c
  dec  hl
  ld   (hl),a
  ret
ImageDraw:
  ld  a,l       ; check in range 0..39 0..23
  cp   24
  ret  nc
  ld   a,h
  cp   40
  ret  nc

  call  IDCalculatePos     ; calculate position on screen -> HL

  ld   a,(de)       ; get X,Y size into A
  inc  de        ; advance into graphic data

  ld   (bc),a       ; write size out to save, so it's a graphic
  inc  bc        ; in its own right.
  ;
  ;   Draw one line A is size, HL screen pos, DE gfx data, BC store.
  ;
_IDOuter:
  push  af        ; save height counter.
  push  hl        ; save screen position, start of line
  and  $0F       ; make A a horizontal counter, e.g. 0..15
  jr   z,_IDDoneBoth     ; width zero, nothing to do.
_IDInner:
  ;
  ;   Save/Copy one byte, go through this twice, once for colour RAM $3000-$33FF and once
  ;   for char RAM $3400-$37FF
  ;
  push  af        ; save A

  ld   a,(hl)       ; get and save old value
  ld   (bc),a
  inc  bc

  ld   a,(de)       ; copy out new value
  or   a        ; zero ?
  jr   nz,_IDNotDefault    ; can't be default
  bit  2,h       ; in char RAM, can't be default
  jr   z,_IDNotDefault
  ld   a,(imageDefaultColour)  ; load default colour
_IDNotDefault:
  ld   (hl),a
  inc  de

  pop  af        ; restore A

  bit  2,h       ; are we in $34xx e.g. have just written to colour RAM
  jr   nz,_IDDoneBoth     ; if so we've done both.
  set  2,h       ; otherwise do the colour RAM copy
  jr   _IDInner
  ;
  ;   Done one character, now advance one right.
  ;
_IDDoneBoth:
  res  2,h       ; back to character RAM.
  inc  hl        ; next character to the right
  dec  a        ; done the lot
  jr   nz,_IDInner      ; no, go back.

  pop  hl        ; restore start of line
  ld   a,l       ; go down one line
  add  a,40
  ld   l,a
  jr   nc,_IDNoCarry
  inc  h
_IDNoCarry:
  pop  af        ; restore line counter
  sub  a,$10       ; decrement the upper nibble of the counter
  cp   a,$10       ; until upper nibble is $00
  jr   nc,_IDOuter

  ret
IDCalculatePos:
  push  de
  ld   a,h       ; save X in A
  ld   h,0       ; HL = Y

  add  hl,hl       ; HL = Y x 8
  add  hl,hl
  add  hl,hl
  ld   e,l       ; DE = Y x 8
  ld  d,h
  add  hl,hl       ; HL = Y x 32
  add  hl,hl
  add  hl,de       ; HL = Y x 40

  ld   e,a       ; DE = X
  ld   d,0
  add  hl,de       ; HL = X + Y x 40

  ld   de,$3028      ; now a screen position
  add  hl,de

  pop  de
  ret
CopySpriteData:
  push  bc
  push  de
  push  hl
  ld   a,(hl)       ; point to sprite in HL and DE
  inc  hl
  ld   h,(hl)
  ld   l,a
  ld   e,l
  ld   d,h
  ld   bc,6       ; HL points to the values, DE to the update values.
  add  hl,bc
  ex   de,hl       ; HL is the update values, DE the target values.
  ld   b,3       ; update potentially three values
_CSDLoop:
  ld   a,(hl)       ; check HL points to $FFFF
  inc  hl
  and  (hl)
  inc  a        ; zero if was $FF
  jr   z,_CSDNext

  dec  hl        ; HL/DE are first byte
  ld   a,(hl)
  ld   (de),a
  ld   (hl),$FF
  inc  de        ; second byte
  inc  hl
  ld   a,(hl)
  ld   (de),a
  ld   (hl),$FF
  dec  de        ; fix so both increments +2
_CSDNext:
  inc  de
  inc  de
  inc  hl
  djnz  _CSDLoop

  pop  hl
  pop  de
  pop  bc
  ret


DrawOneSprite:
  push  bc
  push  de
  push  hl

  ld   a,(hl)       ; point to sprite in HL and BC
  inc  hl
  ld   h,(hl)
  ld   l,a

  ld   bc,12       ; point to storage space HL
  add  hl,bc

  ld   b,h       ; storage space in BC.
  ld   c,l

  dec  hl        ; graphic address in DE.
  ld   d,(hl)
  dec  hl
  ld   e,(hl)

  ld   a,d       ; if $FFFF do
  and  e
  inc  a
  jr   z,_DOSExit

  dec  hl        ; Y in A
  dec  hl
  ld   a,(hl)
  dec  hl        ; X in L
  dec  hl
  ld   h,(hl)
  ld   l,a       ; HL = (X,Y)

  call  ImageDraw      ; draw the image copying the background

_DOSExit:
  pop  hl
  pop  de
  pop  bc
  ret


EraseOneSprite:
  push  bc
  push  de
  push  hl


  ld   a,(hl)       ; point to sprite in HL and DE
  inc  hl
  ld   h,(hl)
  ld   l,a

  ld   bc,12       ; point to storage space.
  add  hl,bc

  ld   d,h       ; storage space in DE, drawing fom here
  ld   e,l

  ld   bc,$0000      ; copy data to ROM.

  dec  hl        ; if graphic is $FFFF do nothing.
  ld   a,(hl)
  dec  hl
  and  (hl)
  inc  a
  jr   z,_EOSExit

  dec  hl        ; Y in A
  dec  hl
  ld   a,(hl)
  dec  hl        ; X in L
  dec  hl
  ld   h,(hl)
  ld   l,a       ; HL = (X,Y)

  call  ImageDraw      ; draw the image copying the background

_EOSExit:
  pop  hl
  pop  de
  pop  bc
  ret