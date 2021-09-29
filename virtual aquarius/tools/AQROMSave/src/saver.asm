	.org $38E1

;	these constants from Kenny's aqromdis.txt 
;		aquarius ROM disassembly
PRNCHR		.EQU $1d94
RECMSG		.EQU $1b7f
SAVESYNC	.EQU $1bbc
TAPEBYTE	.EQU $1b8a
BASTART		.EQU $384F
SAVEBASBLOCK	.EQU $1d38
KEYCHK		.EQU	$1e80

	; make this a load and run program
	; tape synch
	.byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	.byte $00

	; cassette tape file name, 6 characters
	.byte "cartsv"
	; end name

	.byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

	; $3900
	.byte $00
	; line link
	.byte $25,$39
	; line number
	.byte $0a,$00
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
	; line link
linelinkend
	.byte (MLEND & 255)
	.byte (MLEND >> 8)
	; line number
	.byte $28, $00
	; B=USR(0):END
	.byte $42, $B0,$B5,$28,$30,$29,$3A,$80
	.byte $00
	.byte $00,$00
MLSTART
;==================
; cartsaver, write cart to tape
;
cartsaver
	push	af
	push	bc
	push	de
	push	hl

	ld		a,$0b		; clearscreen character
	call	PRNCHR

	xor	a			; let .a = 0
	out	(255),a		; cartridge scrambler
		;ld	hl,cksum7
		;ld	a,(hl)		; lo
		;inc	hl
		;or	(hl)		; +1
		;inc hl
		;or	(hl)		;+1
		;inc hl
		;or	(hl)		;+1
		;inc hl
		;or	(hl)		;(cksumxor)
		;inc hl
		;or	(hl)		;(cksumxor+1)
		;jr	z,dosave
		;-
		;didsave		; here, we've already done a save.  do the checksum and check.
		;- TO DO
		;ret
		;---

dosave		; here, we haven't saved yet.  Do the checksums first.
	xor		a
	out		(255),a		; ROM decoder

	ld		hl,$0000
	ld		bc,$2000
	call	docksums
	ld		hl,cksum7
	ld		bc,6
	ld		de,storedcksumS2
	call	excompare
	jr		z,iss2rom
	ld		hl,notanS2ROMmess
	jr		prns2mess
iss2rom
	ld		hl,isanS2ROMmess
prns2mess
	call	prnmess

	ld		hl,$2000
	ld		bc,$1000
	call	docksums
	ld		de,storedcksumex
	ld		hl,cksum7
	ld		bc,6
	call	excompare
	jr		z,exromempty

exrompresent
	ld		hl,exromfoundmess
	jr		prnexmess
exromempty
	ld		hl,exromemptymess
prnexmess
	call	prnmess

	ld		hl,$c000
	ld		bc,$4000
	call	docksums
	ld		de,storedcksumc000
	ld		hl,cksum7
	ld		bc,6
	call	excompare
	jr		z,gameromempty

gamerompresent
	ld		hl,gameromfoundmess
	jr		prngamerommess
gameromempty
	ld		hl,gameromemptymess
prngamerommess
	call	prnmess


	ld		hl,choosemenu
	call	prnmess


keygetlop
	call	KEYCHK
	nop
	or		a
	jr		z,keygetlop
	cp		'1'
	jr		z,optone
	cp		'2'
	jr		z,opttwo
	cp		'3'
	jr		z,optthree
	cp		'x'
	jr		z,optx
	jr		keygetlop
;-
optx
	call	PRNCHR
	call	clearcksum
	ld		hl,crlfmess
	call	prnmess
	jp		progexit	; exit exit the program back to BASIC


;---
optone
	call	PRNCHR
	ld		hl,$0000
	ld		bc,$2000
	jr		optcommon
;-
opttwo
	call	PRNCHR
	ld		hl,$2000
	ld		bc,$1000
	jr		optcommon
;-
optthree
	call	PRNCHR
	ld		hl,$c000
	ld		bc,$4000
optcommon
	ld		(savstartaddr),hl
	ld		(savlength),bc
	call	docksums		; input .hl and .bc
	ld		hl,crlfmess
	call	prnmess
	call	savecartstuff
	; decide which dim message to print
	ld		hl,whenreloadingmess
	call	prnmess
	ld		a,(savlength+1)
	ld		hl,dima4Kmess
	cp		$10
	jr		z,prndim
	ld		hl,dima8Kmess
	cp		$20
	jr		z,prndim
	ld		hl,dima16Kmess
	cp		$40
	jr		z,prndim
	jp		pastprndim	; no message
prndim
	call	prnmess
pastprndim


progexit
	pop		hl
	pop		de
	pop		bc
	pop		af
	ret



;==================================================================
;	docksums,
;	input
;		.hl source
;		.bc count
docksums	; do the checksums, checksum7 and xored
	push	hl
	push	bc
	call	docksum7
	pop		bc
	pop		hl
	call	docksumxor
	ret

;=====




;==================================================================
;------excompare start
; excompare,
;	INPUT
;		.hl points to something to compare
;		.de points to something to compare it to
;		.bc is bytecount (must be > 0)
;	RETURN
;		z (if equal)
;		nz (if not equal)
;	MUNGES
;		all
excompare
		ld	a,(de)
		cp	(hl)
		ret	nz
		inc	hl
		inc	de
		dec	bc
		ld	a,c
		or	b
		ret	z
		jr	excompare
;------excompare end
	

;==================================================================
; prnmess,
;	print a null-terminated string to the screen
;	INPUT
;		.hl points to null terminated string
;	MUNGES
;		unknown
prnmess
prnmessl1
	ld		a,(hl)
	or		a
	ret		z
	push	hl
	call	PRNCHR
	pop		hl
	inc		hl
	jr		prnmessl1
;------prnmess end



;==================================================================
; tapelenblockwrite,
;	output a block of data to tape
;	
;	INPUT 
;		.hl has pointer to block
;		.de has length of block
tapelenblockwrite
tlbwlop
		ld		a,(hl)
		call	TAPEBYTE
		inc		hl
		dec		de
		ld		a,e
		or		d
		jr		nz,tlbwlop
		ret

;==================================================================
; tapelenrepbytewrite,
;	output a byte, repeated, to tape
;
;	INPUT
;		.a has the byte to write
;		.de has the repetitions (number of times to write it)
;
tapelenrepbytewrite
		ld		l,a
ltapereplop
		ld		a,l
		call    TAPEBYTE		; Save byte in A to tape.
		dec		de
		ld		a,e
		or		d
		jr		nz,ltapereplop
		ld		a,l
		ret


;==================================================================
; savecartstuff,
;	the big tamale.  With headers and footers and synchs,
;	 save one block of
;	(savlength) bytes beginning at address (savstartaddr)
;	This block can be loaded into the Aquarius with cload*a
;
;	INPUT
;		(savlength)	number of bytes in block to save
;		(savstartaddr)	start address of block
;
savecartstuff
        push    hl

		; l1d25:
		; call    RECMSG

		ld		hl,pressrecordmess
		call	prnmess
keygetlopd
		call	KEYCHK
		nop
		or		a
		jr		z,keygetlopd
		cp		13
		jr		nz,keygetlopd
		ld		hl,crlfmess
		call	prnmess
		ld		hl,savingmess
		call	prnmess


        call    SAVESYNC
        ld      b,$06
        ld      hl,savromname

savromnamelop			;l1d30:
		ld      a,(hl)
        inc     hl
        call    TAPEBYTE		; save byte in A to tape
        djnz    savromnamelop


        ;	ld      hl,(BASTART)
		;	call    SAVEBASBLOCK	; save from HL to end of BASIC
		;--
		;jtat block start
		xor		a
		ld		de,6
		call	tapelenrepbytewrite

		ld		hl,SAVEHEADERSTART
		ld		de,SAVEHEADEREND-SAVEHEADERSTART
		call	tapelenblockwrite


		ld		hl,(savstartaddr)
		ld		de,(savlength)
		call	tapelenblockwrite
		ld		hl,endromlabel
		ld		de,6
		call	tapelenblockwrite
		xor		a
		ld		de,3
		call	tapelenrepbytewrite


		;jtat block end
		;--

l1c1c:  ld      b,$0f			; save 16 bytes of $00 to tape.
        xor     a
l1c1f:  call    TAPEBYTE		; Save byte in A to tape.
        djnz    l1c1f             ; Decerement B and loop accordingly.
        ld      bc,$6000		; Then pause for bc loops ($2000=Approx 1 second)
SLEEPBC
		dec     bc			; decrement the loop counter.
        ld      a,b			; check if B and C are both 00
        or      c			
        jr      nz,SLEEPBC        ; Loop till BC = 00.
		ld		hl,savedmess
		call	prnmess
        pop     hl
l1c2b:  ret     
;------




;==================================================================
; docksum7,
;	cksum7 a block ofmemory
;	
;	INPUT
;		.hl	point to start of block to checksum
;		.bc length of block to checksum
;
;	OUTPUT
;		results are put into four bytes, cksum7 through cksum7+3
docksum7
	ld	a,1
	ld	(ckfactor1),a
	xor	a
	ld	(cksum7),a
	ld	(cksum7+1),a
	ld	(cksum7+2),a
	ld	(cksum7+3),a

cksum7outerlop
	push	hl		; push the mempointer
	ld	a,(hl)		; fetch memory byte
	ld	e,a
	ld	d,0			; put memory byte into .de
	inc	de			; and add 1
	ld	hl,0
	ld	a,(ckfactor1)
cksum7f1lop
	add	hl,de
	dec	a
	jr	nz,cksum7f1lop
	; here, have the ckfactor1 * (membyte + 1) in .hl
	ld	a,(cksum7)
	add	a,l
	ld	(cksum7),a
	ld	a,(cksum7+1)
	adc	a,h
	ld	(cksum7+1),a
	ld	a,(cksum7+2)
	adc	a,0
	ld	(cksum7+2),a
	ld	a,(cksum7+3)
	adc	a,0
	ld	(cksum7+3),a
	ld	a,(ckfactor1)
	inc	a
	cp	8
	jr	nz,stockfactor1
	ld	a,1
stockfactor1
	ld	(ckfactor1),a	; ckfactor1++; if (ckfactor1 > 7) ckfactor1 = 1;

	pop	hl			; get the mempointer back
	inc	hl
	dec	bc
	ld	a,b
	or	c
	jr	nz,cksum7outerlop
	ret


;==================================================================
; docksumxor,
;	cksumxor a block ofmemory
;	
;	INPUT
;		.hl	point to start of block to checksum
;		.bc length of block to checksum
;
;	OUTPUT
;		results are put into two bytes, cksumxor through cksumxor+1
;
;	ALGORITHM
;		fetch a byte from memory.  xor it with the low byte of
;		the running checksum.  Do a 16-bit circular rotate on
;		the running checksum (I think I got this from Compute!
;		magazine)
docksumxor
	ld	de,0		; keeping result in .de
cksumxorl1
	ld	a,(hl)		; fetch memory byte
	xor	e
	ld	e,a			; xored with cumulative
	sla	e
	rl	d
	jr	nc,cksumxorl1nex
	inc	de			; did a 16-bit rotate on .de
cksumxorl1nex
	inc	hl
	dec	bc
	ld	a,b
	or	c
	jr	nz,cksumxorl1
	;- out
	ld	(cksumxor),de	; store result
	ret

;==================================================================
; clearcksum
;	clear both cksum7 and cksumxor to 0
clearcksum
	xor		a				; set .a to 0
	ld		(cksumxor),a
	ld		(cksumxor+1),a
	ld		c,6
	ld		hl,cksum7
clearcksumlop
	ld		(hl),a
	inc		hl
	dec		c
	jr		nz,clearcksumlop
	ret
;=======


;==================================================================
;	data area
;		If I were diligent, I'd separate bss (init to 0)
;		from
;		other initialized data.
;		But I'm not.

ckfactor1
	.byte 0

savingmess	.byte 13,10,"Saving... ",0
savedmess	.byte "Saved.",13,10,0
whenreloadingmess	.byte "When reloading use ",0

	; dim/csave*a
	; 418bytes-> 100elements     58->10
	; 4bytes per element+18bytes
	; 
dima4Kmess	.byte "dima(1044)",13,10,0
dima8Kmess	.byte "dima(2068)",13,10,0
dima16Kmess	.byte "dima(4116)",13,10,0

choosemenu
	.byte 13,10,13,10
	.byte "1. Save BASIC ROM $0000-$1FFF",13,10
	.byte "2. Save Ex ROM $2000-$2FFF",13,10
	.byte "3. Save Game ROM $C000-$FFFF",13,10
	.byte "x. Exit this program",13,10
	.byte 13,10
	.byte " Pick 1,2,3, or x: ",0

pressrecordmess	.byte "Press RECORD, then press RETURN"
				.byte 0

crlfmess		.byte 13,10,0



notanS2ROMmess		.byte "BASIC ROM is NOT standard S2",13,10,0
isanS2ROMmess		.byte "Standard BASIC S2 ROM",13,10,0

gameromemptymess		.byte "NO ROM at $C000-$FFFF",13,10,0
gameromfoundmess		.byte "Found: ROM at $C000-$FFFF",13,10,0

exromemptymess		.byte "NO ROM at $2000-$2FFF",13,10,0
exromfoundmess		.byte "Found: ROM at $2000-$2FFF",13,10,0


					
storedcksumS2		.byte $9b,$28,$36,$00,$66,$f7
					.byte "overrun2"
storedcksumex		.byte $00,$FD,$3F,$00,$00,$00	; stored checksum for nothing at $2000-$2FFF
					.byte "overrun3"

storedcksumc000		.byte $00,$FA,$FF,$00,$00,$00	; stored checksum for nothing at $C000-$FFFF

savromname
	.byte "######"

SAVEHEADERSTART
	.byte "savestart"
savstartaddr	.byte 0, 0
	.byte "savelength"
savlength		.byte 0,0
	.byte "startcksum"
cksum7
	.byte 0, 0, 0, 0
cksumxor
	.byte 0, 0
	.byte "endcksum"
startromlabel
	.byte "startrom"
SAVEHEADEREND


endromlabel
	.byte "endrom"

endsavermarker
	.byte "endsaver"
	.byte 0, 0, 0, 0

MLEND
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00



	.end
