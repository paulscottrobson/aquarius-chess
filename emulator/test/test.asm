;
;		Testing program.
;

temp0 = $00
temp1 = $02

videoLow = $D000+5+4*32
videoHigh = $D000+10+5*64

video = videoHigh

	* =	$E000
	.binary "character.rom",$0000,32*8
	.binary "cpc6128.rom",$3900,96*8
	.binary "character.rom",$400,128*8

start:	
	lda 	#$E0
	jsr 	UDGCopy
	lda 	#$E8
	jsr 	UDGCopy

	lda 	#$FF
	sta 	$E000+97*8
	sta 	$E001+97*8
	sta 	$E002+97*8

	sta 	$E803+97*8
	sta 	$E805+97*8
	sta 	$E807+97*8

	lda 	#$83+8+16
	sta 	$FFFF
	lda 	#$00
	sta 	temp0
	lda 	#$D0
	sta 	temp0+1
	ldy 	#0
loop1:
	tya
	sta 	(temp0),y
	iny
	bne 	loop1
	inc 	temp0+1
	lda 	temp0+1
	cmp 	#$E0
	bne 	loop1	

h1:	jmp 	h1

UDGCopy:
	sta 	temp1+1
	lda 	#$E0
	sta 	temp0+1
	lda 	#0
	sta 	temp0
	sta 	temp1
	tay
	ldx 	#8
_UCopy1:
	lda 	(temp0),y
	and 	#$AA
	sta 	(temp1),y
	iny
	bne 	_UCopy1
	inc 	temp0+1
	inc 	temp1+1
	dex
	bne 	_UCopy1
	rts

	* =	$FFFA
	.word 	0								; NMI
	.word 	start 							; Reset
	.word 	0 								; IRQ

