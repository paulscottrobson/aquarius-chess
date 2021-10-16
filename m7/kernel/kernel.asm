Main:
	ld 		hl,testCode
	call 	CompileStream

WarmStart:
	.byte $76
	ld 		sp,(StackPointer)
	jp 		WarmStart	

	.include 	"code.asm"
	.include 	"compiler.asm"
	.include 	"search.asm"
	