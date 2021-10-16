Main:
	ld 		hl,testCode
	call 	CompileStream

WarmStart:
	ld 		sp,(StackPointer)
	jp 		WarmStart	

WordIsCompileOnly:
	halt
	jr 		WordIsCompileOnly

UnknownWord:
	halt
	jr 		UnknownWord

	.include 	"code.asm"
	.include 	"compiler.asm"
	.include 	"search.asm"
	.include 	"toint.asm"
	