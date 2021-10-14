; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		register.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		5th January 2019
;		Purpose :	Register manipulation
;
; ***************************************************************************************
; ***************************************************************************************

@xmacro	swap
		ex 		de,hl
@end

; ***************************************************************************************

@xmacro a>b
		ld 		d,h
		ld 		e,l
@end

@xmacro a>c
		ld 		b,h
		ld 		c,l
@end

; ***************************************************************************************

@xmacro b>a
		ld 		h,d
		ld 		l,e
@end

@xmacro b>c
		ld 		b,d
		ld 		c,e
@end

; ***************************************************************************************

@xmacro c>a
		ld 		h,b
		ld 		l,c
@end

@xmacro c>b
		ld 		d,b
		ld 		e,c
@end

