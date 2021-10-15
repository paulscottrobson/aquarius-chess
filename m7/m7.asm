

	.org $C000

	nop

	.org $E000
	.db  "PSR",0
	.db  0,$9C,0,$B0,0,$6C,0,$64,0,$A8,$5F,$70
	.org $E010
	.byte $76
