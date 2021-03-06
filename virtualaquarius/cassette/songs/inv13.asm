	.org $38E1
	.byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	.byte $00

	; cassette tape file name, 6 characters
	.byte "testsa"
	; end name

	.byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

	; $3900
	.byte $00
	; line link, line number
	.byte $25,$39,$0a,$00
	; rem
	.byte $8e
	.byte " for Aquarius S2 (do not edit)"
	.byte 00
	; line link, line number
	.byte $2d, $39, $14, $00
	; B=0
	.byte $42, $B0, $30
	.byte 00
	; line link, line number
	.byte $49, $39, $1e, $00
	; poke 14340,nnn:poke 14341,mmm
	.byte $94, $20, "14340", $2C, "088"
	.byte $3A
	.byte $94, $20, "14341", $2C, "057"
	.byte 00
	; line link, line number
	.byte (MLEND & 255)
	.byte (MLEND >> 8)
	.byte $28, $00
	; B=USR(0):END
	.byte $42, $B0,$B5,$28,$30,$29,$3A,$80
	.byte $00
	.byte $00,$00
MLSTART


;==================
; playsong,
;	play a song located at songstart
;	James the Animal Tamer
playsong
	ld	hl,songstart
playline
	ld	a,(hl)			; get wait
	inc	hl
	ld	c,a				; hold wait in .c
	ld	a,(hl)			; get number of registers
	inc	hl
	ld	b,a				; hold number of registers in .b
	or	c
	jr	z,playsongend
;-
	call	waittof		; wait top of frame, c times
	; number of registers is in .b
	; .hl points to register to change data
_reglop
	ld	a,(hl)
	inc	hl
	out	(247),a		; register select
	ld	a,(hl)
	inc	hl
	out	(246),a
	dec	b
	jr	nz,_reglop
	jr	playline
;---
playsongend
	ret

;==================
; waittof,
;	wait top of frame, c times
;	preserve registers
waittof
	push	af
	push	bc

	ld	b,c

    ld  c,253
_lop1
    in  a,(c)
    bit 0,a
    jr  z,_invblanka
    jr  nz,_lop1
_invblanka
    in  a,(c)
    bit 0,a
    jr  z,_invblanka

	dec		b
	jr		nz,_lop1
	pop		bc
	pop		af
	ret


songstart
	; rem  song
	; rem wait, number of registers to change,
	;	register number, new value
	;	register number, new value
	;	etc.
	; ends when number of registers to change is 0.
	.byte 1,4,  8,0, 9,0, 10,0, 7,56
	;-- snip
    .byte 1,3,0,112,1,4,8,15
    .byte 10,3,2,123,3,1,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,28,1,1,8,15,2,56,3,2,9,15
    .byte 9,1,8,0
    .byte 1,3,0,238,1,0,8,15
    .byte 9,1,8,0
    .byte 1,3,0,253,1,0,8,15
    .byte 9,1,8,0
    .byte 1,3,0,123,1,1,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,253,1,0,8,15,2,89,3,2,9,15
    .byte 9,1,8,0
    .byte 1,3,0,212,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,238,1,0,8,15,2,56,3,2,9,15
    .byte 9,1,9,0
    .byte 1,3,2,246,3,2,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,189,1,0,8,15,2,56,3,2,9,15
    .byte 9,1,9,0
    .byte 1,3,2,221,3,1,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,44,1,1,8,15,2,250,3,1,9,15
    .byte 9,1,9,0
    .byte 1,3,2,246,3,2,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,189,1,0,8,15,2,250,3,1,9,15
    .byte 9,1,9,0
    .byte 1,3,2,169,3,1,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,28,1,1,8,15,2,221,3,1,9,15
    .byte 9,1,8,0
    .byte 1,3,0,123,1,1,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,28,1,1,8,15,2,56,3,2,9,15
    .byte 9,1,8,0
    .byte 1,3,0,238,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,253,1,0,8,15,2,89,3,2,9,15
    .byte 9,1,8,0
    .byte 1,3,0,123,1,1,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,253,1,0,8,15,2,246,3,2,9,15
    .byte 9,1,8,0
    .byte 1,3,0,212,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,238,1,0,8,15,2,56,3,2,9,15
    .byte 9,1,9,0
    .byte 1,3,2,246,3,2,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,28,1,1,8,15,2,56,3,2,9,15
    .byte 9,1,9,0
    .byte 1,3,2,221,3,1,9,15
    .byte 9,2,8,0,9,0
    .byte 1,3,0,250,1,1,8,15
    .byte 9,1,8,0
    .byte 1,3,0,246,1,2,8,15
    .byte 9,1,8,0
    .byte 1,3,0,250,1,1,8,15
    .byte 9,1,8,0
    .byte 1,3,0,169,1,1,8,15
    .byte 9,1,8,0
    .byte 1,3,0,221,1,1,8,15
    .byte 10,3,2,189,3,0,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,238,1,0,8,15,2,56,3,2,9,15
    .byte 9,1,8,0
    .byte 1,3,0,189,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,28,1,1,8,15,2,221,3,1,9,15
    .byte 9,1,8,0
    .byte 1,3,0,238,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,123,1,1,8,15,2,56,3,2,9,15
    .byte 9,1,8,0
    .byte 1,3,0,62,1,1,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,101,1,1,8,15,2,169,3,1,9,15
    .byte 9,1,9,0
    .byte 1,3,2,56,3,2,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,28,1,1,8,15,2,203,3,2,9,15
    .byte 9,1,9,0
    .byte 1,3,2,56,3,2,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,212,1,0,8,15,2,83,3,3,9,15
    .byte 9,1,9,0
    .byte 1,3,2,203,3,2,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,178,1,0,8,15,2,112,3,4,9,15
    .byte 9,1,9,0
    .byte 1,3,2,187,3,3,9,15
    .byte 9,1,9,0
    .byte 1,3,2,244,3,3,9,15
    .byte 9,1,8,0
    .byte 1,3,0,212,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,253,1,0,8,15,2,83,3,3,9,15
    .byte 9,1,8,0
    .byte 1,3,0,212,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,62,1,1,8,15,2,125,3,2,9,15
    .byte 9,1,8,0
    .byte 1,3,0,253,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,169,1,1,8,15,2,250,3,1,9,15
    .byte 9,1,8,0
    .byte 1,3,0,101,1,1,8,15
    .byte 9,1,8,0
    .byte 1,3,0,123,1,1,8,15
    .byte 9,1,9,0
    .byte 1,3,2,125,3,2,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,62,1,1,8,15,2,246,3,2,9,15
    .byte 9,1,9,0
    .byte 1,3,2,125,3,2,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,238,1,0,8,15,2,187,3,3,9,15
    .byte 9,1,9,0
    .byte 1,3,2,246,3,2,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,189,1,0,8,15,2,251,3,4,9,15
    .byte 9,1,9,0
    .byte 1,3,2,244,3,3,9,15
    .byte 9,1,9,0
    .byte 1,3,2,112,3,4,9,15
    .byte 9,1,8,0
    .byte 1,3,0,238,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,28,1,1,8,15,2,187,3,3,9,15
    .byte 9,1,8,0
    .byte 1,3,0,238,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,101,1,1,8,15,2,83,3,3,9,15
    .byte 9,1,9,0
    .byte 1,3,2,203,3,2,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,212,1,0,8,15,2,244,3,3,9,15
    .byte 9,1,9,0
    .byte 1,3,2,83,3,3,9,15
    .byte 9,1,9,0
    .byte 1,3,2,251,3,4,9,15
    .byte 9,1,8,0
    .byte 1,3,0,253,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,62,1,1,8,15,2,244,3,3,9,15
    .byte 9,1,8,0
    .byte 1,3,0,253,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,123,1,1,8,15,2,187,3,3,9,15
    .byte 9,1,9,0
    .byte 1,3,2,246,3,2,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,238,1,0,8,15,2,112,3,4,9,15
    .byte 9,1,9,0
    .byte 1,3,2,187,3,3,9,15
    .byte 9,1,9,0
    .byte 1,3,2,151,3,5,9,15
    .byte 9,1,8,0
    .byte 1,3,0,28,1,1,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,101,1,1,8,15,2,166,3,6,9,15
    .byte 9,1,8,0
    .byte 1,3,0,28,1,1,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,169,1,1,8,15,2,251,3,4,9,15
    .byte 8,1,9,0
    .byte 1,3,2,125,3,2,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,253,1,0,8,15,2,203,3,2,9,15
    .byte 9,1,9,0
    .byte 1,3,2,125,3,2,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,238,1,0,8,15,2,187,3,3,9,15
    .byte 8,1,9,0
    .byte 1,3,2,125,3,2,9,15
    .byte 9,2,8,0,9,0
    .byte 1,3,0,221,1,1,8,15
    .byte 9,1,8,0
    .byte 1,3,0,123,1,1,8,15
    .byte 9,1,8,0
    .byte 1,3,0,169,1,1,8,15
    .byte 9,1,8,0
    .byte 1,3,0,125,1,2,8,15
    .byte 9,1,8,0
    .byte 1,3,0,169,1,1,8,15
    .byte 9,1,8,0
    .byte 1,3,0,101,1,1,8,15
    .byte 9,1,8,0
    .byte 1,3,0,123,1,1,8,15
    .byte 10,3,2,62,3,1,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,238,1,0,8,15,2,221,3,1,9,15
    .byte 9,1,8,0
    .byte 1,3,0,189,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,212,1,0,8,15,2,250,3,1,9,15
    .byte 9,1,8,0
    .byte 1,3,0,62,1,1,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,212,1,0,8,15,2,125,3,2,9,15
    .byte 9,1,8,0
    .byte 1,3,0,178,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,189,1,0,8,15,2,221,3,1,9,15
    .byte 9,1,9,0
    .byte 1,3,2,125,3,2,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,159,1,0,8,15,2,221,3,1,9,15
    .byte 9,1,9,0
    .byte 1,3,2,123,3,1,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,253,1,0,8,15,2,169,3,1,9,15
    .byte 9,1,9,0
    .byte 1,3,2,125,3,2,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,159,1,0,8,15,2,169,3,1,9,15
    .byte 9,1,9,0
    .byte 1,3,2,101,3,1,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,238,1,0,8,15,2,123,3,1,9,15
    .byte 9,1,8,0
    .byte 1,3,0,62,1,1,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,238,1,0,8,15,2,221,3,1,9,15
    .byte 9,1,8,0
    .byte 1,3,0,189,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,3,0,212,1,0,8,15
    .byte 9,1,8,0
    .byte 1,3,0,62,1,1,8,15
    .byte 9,1,8,0
    .byte 1,3,0,212,1,0,8,15
    .byte 9,1,8,0
    .byte 1,3,0,178,1,0,8,15
    .byte 9,1,8,0
    .byte 1,3,0,189,1,0,8,15
    .byte 10,3,2,62,3,1,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,238,1,0,8,15,2,123,3,1,9,15
    .byte 9,1,9,0
    .byte 1,3,2,62,3,1,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,159,1,0,8,15,2,221,3,1,9,15
    .byte 9,1,9,0
    .byte 1,3,2,123,3,1,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,189,1,0,8,15,2,125,3,2,9,15
    .byte 9,1,9,0
    .byte 1,3,2,250,3,1,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,119,1,0,8,15,2,56,3,2,9,15
    .byte 9,1,8,0
    .byte 1,3,0,142,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,189,1,0,8,15,2,221,3,1,9,15
    .byte 9,1,8,0
    .byte 1,3,0,142,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,238,1,0,8,15,2,123,3,1,9,15
    .byte 9,1,8,0
    .byte 1,3,0,189,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,28,1,1,8,15,2,62,3,1,9,15
    .byte 9,1,8,0
    .byte 1,3,0,238,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,212,1,0,8,15,2,81,3,1,9,15
    .byte 9,1,9,0
    .byte 1,3,2,28,3,1,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,168,1,0,8,15,2,169,3,1,9,15
    .byte 9,1,9,0
    .byte 1,3,2,81,3,1,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,142,1,0,8,15,2,56,3,2,9,15
    .byte 9,1,9,0
    .byte 1,3,2,169,3,1,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,119,1,0,8,15,2,163,3,2,9,15
    .byte 9,1,9,0
    .byte 1,3,2,56,3,2,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,126,1,0,8,15,2,125,3,2,9,15
    .byte 9,1,8,0
    .byte 1,3,0,159,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,212,1,0,8,15,2,250,3,1,9,15
    .byte 9,1,8,0
    .byte 1,3,0,159,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,253,1,0,8,15,2,169,3,1,9,15
    .byte 9,1,8,0
    .byte 1,3,0,212,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,62,1,1,8,15,2,81,3,1,9,15
    .byte 9,1,8,0
    .byte 1,3,0,253,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,238,1,0,8,15,2,123,3,1,9,15
    .byte 9,1,9,0
    .byte 1,3,2,62,3,1,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,189,1,0,8,15,2,221,3,1,9,15
    .byte 9,1,9,0
    .byte 1,3,2,123,3,1,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,159,1,0,8,15,2,125,3,2,9,15
    .byte 9,1,9,0
    .byte 1,3,2,221,3,1,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,126,1,0,8,15,2,246,3,2,9,15
    .byte 9,1,9,0
    .byte 1,3,2,125,3,2,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,142,1,0,8,15,2,163,3,2,9,15
    .byte 9,1,8,0
    .byte 1,3,0,168,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,200,1,0,8,15,2,56,3,2,9,15
    .byte 9,1,8,0
    .byte 1,3,0,168,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,253,1,0,8,15,2,250,3,1,9,15
    .byte 9,1,8,0
    .byte 1,3,0,200,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,81,1,1,8,15,2,145,3,1,9,15
    .byte 9,1,8,0
    .byte 1,3,0,28,1,1,8,15
    .byte 9,2,8,0,9,0
    .byte 1,3,0,62,1,1,8,15
    .byte 10,3,2,123,3,1,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,159,1,0,8,15,2,221,3,1,9,15
    .byte 9,1,9,0
    .byte 1,3,2,123,3,1,9,15
    .byte 9,1,9,0
    .byte 1,3,2,56,3,2,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,189,1,0,8,15,2,221,3,1,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,238,1,0,8,15,2,123,3,1,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,189,1,0,8,15,2,62,3,1,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,28,1,1,8,15,2,81,3,1,9,15
    .byte 9,1,9,0
    .byte 1,3,2,169,3,1,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,168,1,0,8,15,2,250,3,1,9,15
    .byte 9,1,9,0
    .byte 1,3,2,169,3,1,9,15
    .byte 9,1,9,0
    .byte 1,3,2,125,3,2,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,212,1,0,8,15,2,250,3,1,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,253,1,0,8,15,2,169,3,1,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,212,1,0,8,15,2,81,3,1,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,62,1,1,8,15,2,123,3,1,9,15
    .byte 9,1,9,0
    .byte 1,3,2,221,3,1,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,189,1,0,8,15,2,56,3,2,9,15
    .byte 9,1,9,0
    .byte 1,3,2,221,3,1,9,15
    .byte 9,1,9,0
    .byte 1,3,2,163,3,2,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,238,1,0,8,15,2,56,3,2,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,28,1,1,8,15,2,221,3,1,9,15
    .byte 9,1,8,0
    .byte 1,3,0,238,1,0,8,15
    .byte 9,1,8,0
    .byte 1,3,0,81,1,1,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,159,1,0,8,15,2,250,3,1,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,168,1,0,8,15,2,221,3,1,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,189,1,0,8,15,2,56,3,2,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,200,1,0,8,15,2,250,3,1,9,15
    .byte 9,1,8,0
    .byte 1,3,0,168,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,253,1,0,8,15,2,244,3,3,9,15
    .byte 9,1,8,0
    .byte 1,3,0,200,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,189,1,0,8,15,2,246,3,2,9,15
    .byte 9,1,9,0
    .byte 1,3,2,123,3,1,9,15
    .byte 9,2,8,0,9,0
    .byte 1,3,0,250,1,1,8,15
    .byte 9,1,8,0
    .byte 1,3,0,125,1,2,8,15
    .byte 9,1,8,0
    .byte 1,3,0,246,1,2,8,15
    .byte 9,1,8,0
    .byte 1,3,0,244,1,3,8,15
    .byte 9,1,8,0
    .byte 1,3,0,251,1,4,8,15
    .byte 9,1,8,0
    .byte 1,3,0,244,1,3,8,15
    .byte 9,1,8,0
    .byte 1,3,0,236,1,5,8,15
    .byte 10,3,2,159,3,0,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,134,1,0,8,15,2,246,3,2,9,15
    .byte 9,1,8,0
    .byte 1,3,0,159,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,189,1,0,8,15,2,125,3,2,9,15
    .byte 9,1,8,0
    .byte 1,3,0,159,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,225,1,0,8,15,2,24,3,2,9,15
    .byte 9,1,8,0
    .byte 1,3,0,189,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,159,1,0,8,15,2,133,3,3,9,15
    .byte 9,1,8,0
    .byte 1,3,0,189,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,3,0,225,1,0,8,15
    .byte 9,1,8,0
    .byte 1,3,0,189,1,0,8,15
    .byte 9,1,8,0
    .byte 1,3,0,28,1,1,8,15
    .byte 9,1,8,0
    .byte 1,3,0,62,1,1,8,15
    .byte 9,1,8,0
    .byte 1,3,0,81,1,1,8,15
    .byte 9,1,8,0
    .byte 1,3,0,123,1,1,8,15
    .byte 9,1,8,0
    .byte 1,3,0,169,1,1,8,15
    .byte 10,3,2,178,3,0,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,142,1,0,8,15,2,83,3,3,9,15
    .byte 9,1,8,0
    .byte 1,3,0,178,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,212,1,0,8,15,2,203,3,2,9,15
    .byte 9,1,8,0
    .byte 1,3,0,178,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,253,1,0,8,15,2,89,3,2,9,15
    .byte 9,1,8,0
    .byte 1,3,0,212,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,178,1,0,8,15,2,244,3,3,9,15
    .byte 9,1,8,0
    .byte 1,3,0,212,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,3,0,253,1,0,8,15
    .byte 9,1,8,0
    .byte 1,3,0,212,1,0,8,15
    .byte 9,1,8,0
    .byte 1,3,0,62,1,1,8,15
    .byte 9,1,8,0
    .byte 1,3,0,101,1,1,8,15
    .byte 9,1,8,0
    .byte 1,3,0,123,1,1,8,15
    .byte 9,1,8,0
    .byte 1,3,0,169,1,1,8,15
    .byte 9,1,8,0
    .byte 1,3,0,221,1,1,8,15
    .byte 10,3,2,189,3,0,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,159,1,0,8,15,2,187,3,3,9,15
    .byte 9,1,8,0
    .byte 1,3,0,189,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,238,1,0,8,15,2,246,3,2,9,15
    .byte 9,1,8,0
    .byte 1,3,0,189,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,28,1,1,8,15,2,163,3,2,9,15
    .byte 9,1,8,0
    .byte 1,3,0,238,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,200,1,0,8,15,2,112,3,4,9,15
    .byte 9,1,8,0
    .byte 1,3,0,238,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,3,0,28,1,1,8,15
    .byte 9,1,8,0
    .byte 1,3,0,238,1,0,8,15
    .byte 9,1,8,0
    .byte 1,3,0,81,1,1,8,15
    .byte 9,1,8,0
    .byte 1,3,0,123,1,1,8,15
    .byte 9,1,8,0
    .byte 1,3,0,145,1,1,8,15
    .byte 9,1,8,0
    .byte 1,3,0,194,1,1,8,15
    .byte 9,1,8,0
    .byte 1,3,0,250,1,1,8,15
    .byte 10,3,2,212,3,0,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,178,1,0,8,15,2,244,3,3,9,15
    .byte 9,1,8,0
    .byte 1,3,0,212,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,253,1,0,8,15,2,83,3,3,9,15
    .byte 9,1,8,0
    .byte 1,3,0,212,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,44,1,1,8,15,2,203,3,2,9,15
    .byte 9,1,8,0
    .byte 1,3,0,253,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,212,1,0,8,15,2,179,3,4,9,15
    .byte 9,1,8,0
    .byte 1,3,0,253,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,3,0,44,1,1,8,15
    .byte 9,1,8,0
    .byte 1,3,0,253,1,0,8,15
    .byte 9,1,8,0
    .byte 1,3,0,123,1,1,8,15
    .byte 9,1,8,0
    .byte 1,3,0,169,1,1,8,15
    .byte 9,1,8,0
    .byte 1,3,0,221,1,1,8,15
    .byte 9,1,8,0
    .byte 1,3,0,250,1,1,8,15
    .byte 9,1,8,0
    .byte 1,3,0,221,1,1,8,15
    .byte 10,3,2,123,3,1,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,28,1,1,8,15,2,56,3,2,9,15
    .byte 9,1,8,0
    .byte 1,3,0,238,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,253,1,0,8,15,2,89,3,2,9,15
    .byte 9,1,8,0
    .byte 1,3,0,123,1,1,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,253,1,0,8,15,2,246,3,2,9,15
    .byte 9,1,8,0
    .byte 1,3,0,212,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,238,1,0,8,15,2,56,3,2,9,15
    .byte 9,1,9,0
    .byte 1,3,2,246,3,2,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,28,1,1,8,15,2,56,3,2,9,15
    .byte 9,1,9,0
    .byte 1,3,2,221,3,1,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,44,1,1,8,15,2,250,3,1,9,15
    .byte 9,1,9,0
    .byte 1,3,2,246,3,2,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,123,1,1,8,15,2,250,3,1,9,15
    .byte 9,1,9,0
    .byte 1,3,2,169,3,1,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,28,1,1,8,15,2,221,3,1,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,238,1,0,8,15,2,123,3,1,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,189,1,0,8,15,2,28,3,1,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,238,1,0,8,15,2,123,3,1,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,28,1,1,8,15,2,221,3,1,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,238,1,0,8,15,2,123,3,1,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,81,1,1,8,15,2,56,3,2,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,28,1,1,8,15,2,221,3,1,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,238,1,0,8,15,2,163,3,2,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,28,1,1,8,15,2,56,3,2,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,81,1,1,8,15,2,221,3,1,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,28,1,1,8,15,2,56,3,2,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,145,1,1,8,15,2,163,3,2,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,238,1,0,8,15,2,56,3,2,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,253,1,0,8,15,2,35,3,3,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,28,1,1,8,15,2,163,3,2,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,44,1,1,8,15,2,246,3,2,9,15
    .byte 9,1,8,0
    .byte 1,3,0,253,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,212,1,0,8,15,2,89,3,2,9,15
    .byte 9,1,8,0
    .byte 1,3,0,253,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,44,1,1,8,15,2,250,3,1,9,15
    .byte 9,1,8,0
    .byte 1,3,0,253,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,169,1,1,8,15,2,89,3,2,9,15
    .byte 9,1,8,0
    .byte 1,3,0,101,1,1,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,44,1,1,8,15,2,246,3,2,9,15
    .byte 9,1,8,0
    .byte 1,3,0,101,1,1,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,169,1,1,8,15,2,244,3,3,9,15
    .byte 9,1,8,0
    .byte 1,3,0,101,1,1,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,250,1,1,8,15,2,179,3,4,9,15
    .byte 9,1,8,0
    .byte 1,3,0,101,1,1,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,123,1,1,8,15,2,236,3,5,9,15
    .byte 9,1,8,0
    .byte 1,3,0,169,1,1,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,221,1,1,8,15,2,112,3,4,9,15
    .byte 9,1,8,0
    .byte 1,3,0,123,1,1,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,28,1,1,8,15,2,187,3,3,9,15
    .byte 9,1,8,0
    .byte 1,3,0,123,1,1,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,221,1,1,8,15,2,246,3,2,9,15
    .byte 9,1,8,0
    .byte 1,3,0,123,1,1,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,56,1,2,8,15,2,187,3,3,9,15
    .byte 9,1,8,0
    .byte 1,3,0,221,1,1,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,145,1,1,8,15,2,112,3,4,9,15
    .byte 9,1,8,0
    .byte 1,3,0,221,1,1,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,56,1,2,8,15,2,187,3,3,9,15
    .byte 9,1,8,0
    .byte 1,3,0,221,1,1,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,163,1,2,8,15,2,71,3,6,9,15
    .byte 9,1,8,0
    .byte 1,3,0,221,1,1,8,15
    .byte 9,2,8,0,9,0
    .byte 1,3,0,250,1,1,8,15
    .byte 9,1,8,0
    .byte 1,3,0,56,1,2,8,15
    .byte 9,1,8,0
    .byte 1,3,0,89,1,2,8,15
    .byte 10,3,2,250,3,1,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,253,1,0,8,15,2,89,3,2,9,15
    .byte 9,1,9,0
    .byte 1,3,2,246,3,2,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,44,1,1,8,15,2,83,3,3,9,15
    .byte 9,1,9,0
    .byte 1,3,2,250,3,1,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,123,1,1,8,15,2,89,3,2,9,15
    .byte 9,1,9,0
    .byte 1,3,2,83,3,3,9,15
    .byte 9,2,8,0,9,0
    .byte 1,3,0,187,1,3,8,15
    .byte 10,3,2,123,3,1,9,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,28,1,1,8,15,2,246,3,2,9,15
    .byte 9,1,8,0
    .byte 1,3,0,238,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,253,1,0,8,15,2,179,3,4,9,15
    .byte 9,1,8,0
    .byte 1,3,0,123,1,1,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,253,1,0,8,15,2,246,3,2,9,15
    .byte 9,1,8,0
    .byte 1,3,0,212,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,238,1,0,8,15,2,112,3,4,9,15
    .byte 9,1,8,0
    .byte 1,3,0,28,1,1,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,238,1,0,8,15,2,163,3,2,9,15
    .byte 9,1,8,0
    .byte 1,3,0,189,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,212,1,0,8,15,2,244,3,3,9,15
    .byte 9,1,8,0
    .byte 1,3,0,253,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,212,1,0,8,15,2,89,3,2,9,15
    .byte 9,1,8,0
    .byte 1,3,0,178,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,189,1,0,8,15,2,187,3,3,9,15
    .byte 9,1,8,0
    .byte 1,3,0,238,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,189,1,0,8,15,2,56,3,2,9,15
    .byte 9,1,8,0
    .byte 1,3,0,159,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,178,1,0,8,15,2,83,3,3,9,15
    .byte 9,1,8,0
    .byte 1,3,0,189,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,212,1,0,8,15,2,24,3,2,9,15
    .byte 9,1,8,0
    .byte 1,3,0,238,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,253,1,0,8,15,2,89,3,2,9,15
    .byte 9,1,8,0
    .byte 1,3,0,238,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,212,1,0,8,15,2,203,3,2,9,15
    .byte 9,1,8,0
    .byte 1,3,0,189,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,178,1,0,8,15,2,83,3,3,9,15
    .byte 9,1,8,0
    .byte 1,3,0,212,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,150,1,0,8,15,2,244,3,3,9,15
    .byte 9,1,8,0
    .byte 1,3,0,212,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,126,1,0,8,15,2,179,3,4,9,15
    .byte 9,1,8,0
    .byte 1,3,0,212,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,238,1,0,8,15,2,112,3,4,9,15
    .byte 9,1,8,0
    .byte 1,3,0,142,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,178,1,0,8,15,2,166,3,6,9,15
    .byte 9,1,8,0
    .byte 1,3,0,212,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,253,1,0,8,15,2,236,3,5,9,15
    .byte 9,1,8,0
    .byte 1,3,0,212,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,44,1,1,8,15,2,151,3,5,9,15
    .byte 9,1,8,0
    .byte 1,3,0,253,1,0,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,238,1,0,8,15,2,71,3,6,9,15
    .byte 9,1,8,0
    .byte 1,3,0,28,1,1,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,123,1,1,8,15,2,236,3,5,9,15
    .byte 9,1,8,0
    .byte 1,3,0,28,1,1,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,253,1,0,8,15,2,246,3,2,9,15
    .byte 9,1,8,0
    .byte 1,3,0,44,1,1,8,15
    .byte 9,2,8,0,9,0
    .byte 1,6,0,28,1,1,8,15,2,112,3,4,9,15
    .byte 9,1,8,0
    .byte 1,3,0,123,1,1,8,15
    .byte 9,1,8,0
    .byte 1,3,0,221,1,1,8,15
    .byte 9,1,8,0
    .byte 1,3,0,123,1,1,8,15
    .byte 9,1,8,0
    .byte 1,3,0,56,1,2,8,15
    .byte 22,2,8,0,9,0
    ;-- unsnip
    .byte 1,3,  8,0, 9,0, 10,0
    .byte 0,0
;=== end of song

MLEND
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00

	

	.end
