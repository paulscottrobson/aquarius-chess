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
	call	CopyFollowing
	.db	endcopy_1014 - $ - 1
  in   l,(c)
  ld   h,0
endcopy_1014:
; --------------------------------------
;             P!
; --------------------------------------
word_1015:
	call	CopyFollowing
	.db	endcopy_1015 - $ - 1
  out  (c),l
endcopy_1015:
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
	call	CopyFollowing
	.db	endcopy_1017 - $ - 1
  ret
endcopy_1017:
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
;             ---
; --------------------------------------
word_1043:
	call	CopyFollowing
	.db	endcopy_1043 - $ - 1
  dec  hl
  dec  hl
endcopy_1043:
; --------------------------------------
;             --
; --------------------------------------
word_1044:
	call	CopyFollowing
	.db	endcopy_1044 - $ - 1
  dec  hl
endcopy_1044:
; --------------------------------------
;             ++
; --------------------------------------
word_1045:
	call	CopyFollowing
	.db	endcopy_1045 - $ - 1
  inc  hl
endcopy_1045:
; --------------------------------------
;             +++
; --------------------------------------
word_1046:
	call	CopyFollowing
	.db	endcopy_1046 - $ - 1
  inc  hl
  inc  hl
endcopy_1046:
; --------------------------------------
;             0-
; --------------------------------------
word_1047:
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
word_1048:
	call	CompileCallFollowing
  bit  7,h
  ld   hl,$0000
  ret  z
  dec  hl
  ret
; --------------------------------------
;             0=
; --------------------------------------
word_1049:
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
word_1050:
	call	CopyFollowing
	.db	endcopy_1050 - $ - 1
  add  hl,hl
endcopy_1050:
; --------------------------------------
;             4*
; --------------------------------------
word_1051:
	call	CopyFollowing
	.db	endcopy_1051 - $ - 1
  add  hl,hl
  add  hl,hl
endcopy_1051:
; --------------------------------------
;             8*
; --------------------------------------
word_1052:
	call	CopyFollowing
	.db	endcopy_1052 - $ - 1
  add  hl,hl
  add  hl,hl
  add  hl,hl
endcopy_1052:
; --------------------------------------
;             16*
; --------------------------------------
word_1053:
	call	CopyFollowing
	.db	endcopy_1053 - $ - 1
  add  hl,hl
  add  hl,hl
  add  hl,hl
  add  hl,hl
endcopy_1053:
; --------------------------------------
;             2/
; --------------------------------------
word_1054:
	call	CopyFollowing
	.db	endcopy_1054 - $ - 1
  sra  h
  rr   l
endcopy_1054:
; --------------------------------------
;             4/
; --------------------------------------
word_1055:
	call	CopyFollowing
	.db	endcopy_1055 - $ - 1
  sra  h
  rr   l
  sra  h
  rr   l
endcopy_1055:
; --------------------------------------
;             ABS
; --------------------------------------
word_1056:
	call	CompileCallFollowing
  bit  7,h
  ret  z
  jp   __negate
; --------------------------------------
;             BSWAP
; --------------------------------------
word_1057:
	call	CopyFollowing
	.db	endcopy_1057 - $ - 1
  ld   a,l
  ld   l,h
  ld   h,a
endcopy_1057:
; --------------------------------------
;             NOT
; --------------------------------------
word_1058:
	call	CompileCallFollowing
  ld   a,h
  cpl
  ld   h,a
  ld   a,l
  cpl
  ld   l,a
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