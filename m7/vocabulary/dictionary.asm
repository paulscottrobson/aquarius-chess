; <
	.db	$80
	.dw	word_1000
	.db	$bc
; =
	.db	$80
	.dw	word_1001
	.db	$bd
; -
	.db	$80
	.dw	word_1002
	.db	$ad
; +
	.db	$80
	.dw	word_1003
	.db	$ab
; AND
	.db	$80
	.dw	word_1004
	.db	$1,$e,$84
; OR
	.db	$80
	.dw	word_1005
	.db	$f,$92
; XOR
	.db	$80
	.dw	word_1006
	.db	$18,$f,$92
; /
	.db	$80
	.dw	word_1007
	.db	$af
; MOD
	.db	$80
	.dw	word_1008
	.db	$d,$f,$84
; !
	.db	$80
	.dw	word_1009
	.db	$a1
; @
	.db	$80
	.dw	word_1010
	.db	$80
; +!
	.db	$80
	.dw	word_1011
	.db	$2b,$a1
; C!
	.db	$80
	.dw	word_1012
	.db	$3,$a1
; C@
	.db	$80
	.dw	word_1013
	.db	$3,$80
; P@
	.db	$80
	.dw	word_1014
	.db	$10,$80
; P!
	.db	$80
	.dw	word_1015
	.db	$10,$a1
; ,
	.db	$80
	.dw	word_1016
	.db	$ac
; ;
	.db	$81
	.dw	word_1017
	.db	$bb
; C,
	.db	$80
	.dw	word_1018
	.db	$3,$ac
; COPY
	.db	$80
	.dw	word_1019
	.db	$3,$f,$10,$99
; FILL
	.db	$80
	.dw	word_1020
	.db	$6,$9,$c,$8c
; HALT
	.db	$80
	.dw	word_1021
	.db	$8,$1,$c,$94
; BREAK
	.db	$80
	.dw	word_1022
	.db	$2,$12,$5,$1,$8b
; *
	.db	$80
	.dw	word_1023
	.db	$aa
; SWAP
	.db	$80
	.dw	word_1024
	.db	$13,$17,$1,$90
; A>B
	.db	$80
	.dw	word_1025
	.db	$1,$3e,$82
; A>C
	.db	$80
	.dw	word_1026
	.db	$1,$3e,$83
; B>A
	.db	$80
	.dw	word_1027
	.db	$2,$3e,$81
; B>C
	.db	$80
	.dw	word_1028
	.db	$2,$3e,$83
; C>A
	.db	$80
	.dw	word_1029
	.db	$3,$3e,$81
; C>B
	.db	$80
	.dw	word_1030
	.db	$3,$3e,$82
; PUSH
	.db	$81
	.dw	word_1031
	.db	$10,$15,$13,$88
; POP
	.db	$81
	.dw	word_1032
	.db	$10,$f,$90
; A>R
	.db	$81
	.dw	word_1033
	.db	$1,$3e,$92
; R>A
	.db	$81
	.dw	word_1034
	.db	$12,$3e,$81
; B>R
	.db	$81
	.dw	word_1035
	.db	$2,$3e,$92
; R>B
	.db	$81
	.dw	word_1036
	.db	$12,$3e,$82
; C>R
	.db	$81
	.dw	word_1037
	.db	$3,$3e,$92
; R>C
	.db	$81
	.dw	word_1038
	.db	$12,$3e,$83
; AB>R
	.db	$81
	.dw	word_1039
	.db	$1,$2,$3e,$92
; R>AB
	.db	$81
	.dw	word_1040
	.db	$12,$3e,$1,$82
; ABC>R
	.db	$81
	.dw	word_1041
	.db	$1,$2,$3,$3e,$92
; R>ABC
	.db	$81
	.dw	word_1042
	.db	$12,$3e,$1,$2,$83
; ---
	.db	$80
	.dw	word_1043
	.db	$2d,$2d,$ad
; --
	.db	$80
	.dw	word_1044
	.db	$2d,$ad
; ++
	.db	$80
	.dw	word_1045
	.db	$2b,$ab
; +++
	.db	$80
	.dw	word_1046
	.db	$2b,$2b,$ab
; 0-
	.db	$80
	.dw	word_1047
	.db	$30,$ad
; 0<
	.db	$80
	.dw	word_1048
	.db	$30,$bc
; 0=
	.db	$80
	.dw	word_1049
	.db	$30,$bd
; 2*
	.db	$80
	.dw	word_1050
	.db	$32,$aa
; 4*
	.db	$80
	.dw	word_1051
	.db	$34,$aa
; 8*
	.db	$80
	.dw	word_1052
	.db	$38,$aa
; 16*
	.db	$80
	.dw	word_1053
	.db	$31,$36,$aa
; 2/
	.db	$80
	.dw	word_1054
	.db	$32,$af
; 4/
	.db	$80
	.dw	word_1055
	.db	$34,$af
; ABS
	.db	$80
	.dw	word_1056
	.db	$1,$2,$93
; BSWAP
	.db	$80
	.dw	word_1057
	.db	$2,$13,$17,$1,$90
; NOT
	.db	$80
	.dw	word_1058
	.db	$e,$f,$94
	.db	$00
