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


link0:
; --------------------------------------
;             <
; --------------------------------------
 .dw 0
 .db $0
 .db $bc
 call CompileCallFollowing
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
link1:
; --------------------------------------
;             =
; --------------------------------------
 .dw link0
 .db $0
 .db $bd
 call CompileCallFollowing
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
link2:
; --------------------------------------
;             -
; --------------------------------------
 .dw link1
 .db $0
 .db $ad
 call CompileCallFollowing
 push  de           ; save DE
 ex   de,hl          ; HL = B, DE = A
 xor  a            ; clear carry
 sbc  hl,de          ; calculate B-A
 pop  de           ; restore DE
 ret
link3:
; --------------------------------------
;             +
; --------------------------------------
 .dw link2
 .db $1
 .db $ab
 call CopyFollowing
 .db endcopy_3 - * - 1
 add  hl,de
endcopy_3:
link4:
; --------------------------------------
;             AND
; --------------------------------------
 .dw link3
 .db $0
 .db $1,$e,$84
 call CompileCallFollowing
 ld   a,h
 and  d
 ld   h,a
 ld   a,l
 and  e
 ld   l,a
 ret
link5:
; --------------------------------------
;             OR
; --------------------------------------
 .dw link4
 .db $0
 .db $f,$92
 call CompileCallFollowing
 ld   a,h
 or   d
 ld   h,a
 ld   a,l
 or   e
 ld   l,a
 ret
link6:
; --------------------------------------
;             XOR
; --------------------------------------
 .dw link5
 .db $0
 .db $18,$f,$92
 call CompileCallFollowing
 ld   a,h
 xor  d
 ld   h,a
 ld   a,l
 xor  e
 ld   l,a
 ret
link7:
; --------------------------------------
;             /
; --------------------------------------
 .dw link6
 .db $0
 .db $af
 call CompileCallFollowing
 push  de
 call  DIVDivideMod16
 ex   de,hl
 pop  de
 ret
link8:
; --------------------------------------
;             MOD
; --------------------------------------
 .dw link7
 .db $0
 .db $d,$f,$84
 call CompileCallFollowing
 push  de
 call  DIVDivideMod16
 pop  de
 ret
link9:
; --------------------------------------
;             !
; --------------------------------------
 .dw link8
 .db $1
 .db $a1
 call CopyFollowing
 .db endcopy_9 - * - 1
  ld   (hl),e
  inc  hl
  ld   (hl),d
  dec  hl
endcopy_9:
link10:
; --------------------------------------
;             @
; --------------------------------------
 .dw link9
 .db $1
 .db $80
 call CopyFollowing
 .db endcopy_10 - * - 1
  ld   a,(hl)
  inc  hl
  ld  h,(hl)
  ld  l,a
endcopy_10:
link11:
; --------------------------------------
;             +!
; --------------------------------------
 .dw link10
 .db $0
 .db $2b,$a1
 call CompileCallFollowing
  ld   a,(hl)
  add  a,e
  ld   (hl),a
  inc  hl
  ld   a,(hl)
  adc  a,d
  ld   (hl),a
  dec  hl
  ret
link12:
; --------------------------------------
;             C!
; --------------------------------------
 .dw link11
 .db $1
 .db $3,$a1
 call CopyFollowing
 .db endcopy_12 - * - 1
  ld   (hl),e
endcopy_12:
link13:
; --------------------------------------
;             C@
; --------------------------------------
 .dw link12
 .db $1
 .db $3,$80
 call CopyFollowing
 .db endcopy_13 - * - 1
  ld   l,(hl)
  ld   h,0
endcopy_13:
link14:
; --------------------------------------
;             P@
; --------------------------------------
 .dw link13
 .db $1
 .db $10,$80
 call CopyFollowing
 .db endcopy_14 - * - 1
  in   l,(c)
  ld   h,0
endcopy_14:
link15:
; --------------------------------------
;             P!
; --------------------------------------
 .dw link14
 .db $1
 .db $10,$a1
 call CopyFollowing
 .db endcopy_15 - * - 1
  out  (c),l
endcopy_15:
link16:
; --------------------------------------
;             ,
; --------------------------------------
 .dw link15
 .db $0
 .db $ac
 call CompileCallFollowing
  jp   FARCompileWord
link17:
; --------------------------------------
;             ;
; --------------------------------------
 .dw link16
 .db $81
 .db $bb
 call CopyFollowing
 .db endcopy_17 - * - 1
  ret
endcopy_17:
link18:
; --------------------------------------
;             C,
; --------------------------------------
 .dw link17
 .db $0
 .db $3,$ac
 call CompileCallFollowing
  ld   a,l
  jp   FARCompileWord
link19:
; --------------------------------------
;             COPY
; --------------------------------------
 .dw link18
 .db $0
 .db $3,$f,$10,$99
 call CompileCallFollowing
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
link20:
; --------------------------------------
;             FILL
; --------------------------------------
 .dw link19
 .db $0
 .db $6,$9,$c,$8c
 call CompileCallFollowing
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
link21:
; --------------------------------------
;             HALT
; --------------------------------------
 .dw link20
 .db $0
 .db $8,$1,$c,$94
 call CompileCallFollowing
__halt_loop:
  di
  halt
  jr   __halt_loop
link22:
; --------------------------------------
;             *
; --------------------------------------
 .dw link21
 .db $0
 .db $aa
 call CompileCallFollowing
 jp   MULTMultiply16
link23:
; --------------------------------------
;             SWAP
; --------------------------------------
 .dw link22
 .db $1
 .db $13,$17,$1,$90
 call CopyFollowing
 .db endcopy_23 - * - 1
  ex   de,hl
endcopy_23:
link24:
; --------------------------------------
;             A>B
; --------------------------------------
 .dw link23
 .db $1
 .db $1,$3e,$82
 call CopyFollowing
 .db endcopy_24 - * - 1
  ld   d,h
  ld   e,l
endcopy_24:
link25:
; --------------------------------------
;             A>C
; --------------------------------------
 .dw link24
 .db $1
 .db $1,$3e,$83
 call CopyFollowing
 .db endcopy_25 - * - 1
  ld   b,h
  ld   c,l
endcopy_25:
link26:
; --------------------------------------
;             B>A
; --------------------------------------
 .dw link25
 .db $1
 .db $2,$3e,$81
 call CopyFollowing
 .db endcopy_26 - * - 1
  ld   h,d
  ld   l,e
endcopy_26:
link27:
; --------------------------------------
;             B>C
; --------------------------------------
 .dw link26
 .db $1
 .db $2,$3e,$83
 call CopyFollowing
 .db endcopy_27 - * - 1
  ld   b,d
  ld   c,e
endcopy_27:
link28:
; --------------------------------------
;             C>A
; --------------------------------------
 .dw link27
 .db $1
 .db $3,$3e,$81
 call CopyFollowing
 .db endcopy_28 - * - 1
  ld   h,b
  ld   l,c
endcopy_28:
link29:
; --------------------------------------
;             C>B
; --------------------------------------
 .dw link28
 .db $1
 .db $3,$3e,$82
 call CopyFollowing
 .db endcopy_29 - * - 1
  ld   d,b
  ld   e,c
endcopy_29:
link30:
; --------------------------------------
;             PUSH
; --------------------------------------
 .dw link29
 .db $81
 .db $10,$15,$13,$88
 call CopyFollowing
 .db endcopy_30 - * - 1
 push  hl
endcopy_30:
link31:
; --------------------------------------
;             POP
; --------------------------------------
 .dw link30
 .db $81
 .db $10,$f,$90
 call CopyFollowing
 .db endcopy_31 - * - 1
 ex   de,hl
 pop  hl
endcopy_31:
link32:
; --------------------------------------
;             A>R
; --------------------------------------
 .dw link31
 .db $81
 .db $1,$3e,$92
 call CopyFollowing
 .db endcopy_32 - * - 1
 push  hl
endcopy_32:
link33:
; --------------------------------------
;             R>A
; --------------------------------------
 .dw link32
 .db $81
 .db $12,$3e,$81
 call CopyFollowing
 .db endcopy_33 - * - 1
 pop  hl
endcopy_33:
link34:
; --------------------------------------
;             B>R
; --------------------------------------
 .dw link33
 .db $81
 .db $2,$3e,$92
 call CopyFollowing
 .db endcopy_34 - * - 1
 push  de
endcopy_34:
link35:
; --------------------------------------
;             R>B
; --------------------------------------
 .dw link34
 .db $81
 .db $12,$3e,$82
 call CopyFollowing
 .db endcopy_35 - * - 1
 pop  de
endcopy_35:
link36:
; --------------------------------------
;             C>R
; --------------------------------------
 .dw link35
 .db $81
 .db $3,$3e,$92
 call CopyFollowing
 .db endcopy_36 - * - 1
 push  bc
endcopy_36:
link37:
; --------------------------------------
;             R>C
; --------------------------------------
 .dw link36
 .db $81
 .db $12,$3e,$83
 call CopyFollowing
 .db endcopy_37 - * - 1
 pop  bc
endcopy_37:
link38:
; --------------------------------------
;             AB>R
; --------------------------------------
 .dw link37
 .db $81
 .db $1,$2,$3e,$92
 call CopyFollowing
 .db endcopy_38 - * - 1
 push  de
 push  hl
endcopy_38:
link39:
; --------------------------------------
;             R>AB
; --------------------------------------
 .dw link38
 .db $81
 .db $12,$3e,$1,$82
 call CopyFollowing
 .db endcopy_39 - * - 1
 pop  hl
 pop  de
endcopy_39:
link40:
; --------------------------------------
;             ABC>R
; --------------------------------------
 .dw link39
 .db $81
 .db $1,$2,$3,$3e,$92
 call CopyFollowing
 .db endcopy_40 - * - 1
 push  bc
 push  de
 push  hl
endcopy_40:
link41:
; --------------------------------------
;             R>ABC
; --------------------------------------
 .dw link40
 .db $81
 .db $12,$3e,$1,$2,$83
 call CopyFollowing
 .db endcopy_41 - * - 1
 pop  hl
 pop  de
 pop  bc
endcopy_41:
link42:
; --------------------------------------
;             --
; --------------------------------------
 .dw link41
 .db $1
 .db $2d,$ad
 call CopyFollowing
 .db endcopy_42 - * - 1
  dec  hl
endcopy_42:
link43:
; --------------------------------------
;             ---
; --------------------------------------
 .dw link42
 .db $1
 .db $2d,$2d,$ad
 call CopyFollowing
 .db endcopy_43 - * - 1
  dec  hl
  dec  hl
endcopy_43:
link44:
; --------------------------------------
;             ++
; --------------------------------------
 .dw link43
 .db $1
 .db $2b,$ab
 call CopyFollowing
 .db endcopy_44 - * - 1
  inc  hl
endcopy_44:
link45:
; --------------------------------------
;             +++
; --------------------------------------
 .dw link44
 .db $1
 .db $2b,$2b,$ab
 call CopyFollowing
 .db endcopy_45 - * - 1
  inc  hl
  inc  hl
endcopy_45:
link46:
; --------------------------------------
;             0-
; --------------------------------------
 .dw link45
 .db $0
 .db $30,$ad
 call CompileCallFollowing
__negate:
  ld   a,h
  cpl
  ld   h,a
  ld   a,l
  cpl
  ld   l,a
  inc  hl
  ret
link47:
; --------------------------------------
;             0<
; --------------------------------------
 .dw link46
 .db $0
 .db $30,$bc
 call CompileCallFollowing
  bit  7,h
  ld   hl,$0000
  ret  z
  dec  hl
  ret
link48:
; --------------------------------------
;             0=
; --------------------------------------
 .dw link47
 .db $0
 .db $30,$bd
 call CompileCallFollowing
  ld   a,h
  or   l
  ld   hl,$0000
  ret  nz
  dec  hl
  ret
link49:
; --------------------------------------
;             2*
; --------------------------------------
 .dw link48
 .db $1
 .db $32,$aa
 call CopyFollowing
 .db endcopy_49 - * - 1
  add  hl,hl
endcopy_49:
link50:
; --------------------------------------
;             4*
; --------------------------------------
 .dw link49
 .db $1
 .db $34,$aa
 call CopyFollowing
 .db endcopy_50 - * - 1
  add  hl,hl
  add  hl,hl
endcopy_50:
link51:
; --------------------------------------
;             8*
; --------------------------------------
 .dw link50
 .db $1
 .db $38,$aa
 call CopyFollowing
 .db endcopy_51 - * - 1
  add  hl,hl
  add  hl,hl
  add  hl,hl
endcopy_51:
link52:
; --------------------------------------
;             16*
; --------------------------------------
 .dw link51
 .db $1
 .db $31,$36,$aa
 call CopyFollowing
 .db endcopy_52 - * - 1
  add  hl,hl
  add  hl,hl
  add  hl,hl
  add  hl,hl
endcopy_52:
link53:
; --------------------------------------
;             2/
; --------------------------------------
 .dw link52
 .db $1
 .db $32,$af
 call CopyFollowing
 .db endcopy_53 - * - 1
  sra  h
  rr   l
endcopy_53:
link54:
; --------------------------------------
;             4/
; --------------------------------------
 .dw link53
 .db $1
 .db $34,$af
 call CopyFollowing
 .db endcopy_54 - * - 1
  sra  h
  rr   l
  sra  h
  rr   l
endcopy_54:
link55:
; --------------------------------------
;             ABS
; --------------------------------------
 .dw link54
 .db $0
 .db $1,$2,$93
 call CompileCallFollowing
  bit  7,h
  ret  z
  jp   __negate
link56:
; --------------------------------------
;             BSWAP
; --------------------------------------
 .dw link55
 .db $1
 .db $2,$13,$17,$1,$90
 call CopyFollowing
 .db endcopy_56 - * - 1
  ld   a,l
  ld   l,h
  ld   h,a
endcopy_56:
link57:
; --------------------------------------
;             NOT
; --------------------------------------
 .dw link56
 .db $0
 .db $e,$f,$94
 call CompileCallFollowing
  ld   a,h
  cpl
  ld   h,a
  ld   a,l
  cpl
  ld   l,a
  ret
