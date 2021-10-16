# ***************************************************************************************
# ***************************************************************************************
#
#		Name : 		tom7.rb
#		Author :	Paul Robson (paul@robsons.org.uk)
#		Date : 		15th October 2021
#		Purpose :	Convert text to M7 storage format.
#
# ***************************************************************************************
# ***************************************************************************************

# ***************************************************************************************
#
#  																	M7 code object
#
# ***************************************************************************************

class CodeObject
	def initialize
		@code = []
		@is_immediate = false
	end 

	def process_block(b)
		b.each { |l| process_line(l.strip.upcase) }
		self
	end 

	def process_line(l)
		if l[0..1] != "//"
			(l.index("//") ? l[..l.index("//")-1] : l).split.each { |w| process_word(w) }
		end
		self
	end

	def process_word(w)
		if w[0] == "["
			@is_immediate = true 
			w = w[1..]
		end
		end_immediate = @is_immediate
		if w[-1] == "]"
			end_immediate = false 
			w = w[..-2]
		end

		if w != ""
			type = @is_immediate ? 0x80:0x40 						# $80 immediate $40 compiled $C0 definition $00 comment
			if w[0] == ":"  										# : prefixed is a red definition.
				type = 0xC0
				w = w[1..]
			end
			@code.append(type|0x20) if @code.length > 0 
			w = w.each_char.collect {|c| (c.ord & 0x3F) | type }	# followed by 6 bit ASCII ored with type byte
			w.each do |c|
				c = c.ord 
				@code.append(c)
			end
		end

		@is_immediate = end_immediate
		self
	end

	def to_hex
		(@code+[0x00]).collect {|b| "$"+b.to_s(16) }.join(",")  	# $00 is the end marker, can't use @ in a comment.
	end
end

s = """
//
// 		M7 Source code
//
	[1 4096 c!]

	:make.immediate -3 h +! ;

	:immediate [make.immediate] make.immediate ;

	:_times_loop variable 
	:_repeat_loop variable 
	:_if_patch variable 

	:times immediate
			h @@ _times_loop !! 	// Save loop back address
			$2B c, 					// DEC  HL
			$E5 c, 					// PUSH HL
	;

	:tend immediate
			$E1 c,					// POP HL
			$7C c, 					// LD A,H
			$B5 c,					// OR L
			$C2 c, _times_loop @@ , // JP NZ,<loop>
	;

	:repeat immediate 
			h @@ _repeat_loop !!
	;

	:until immediate
			$7C c, 					// LD A,H
			$B5 c,					// OR L
			$CA c, _repeat_loop @@ ,// JP Z,<loop>
	;

	:forever immediate
			$C3 c, _repeat_loop @@ ,// JP <loop>
	;

	:if immediate
			$7C c, 					// LD A,H
			$B5 c,					// OR L
			$CA c, 					// JP Z,
			h @@ _if_patch !!  		// Save jump patch
			0 , 		
	;

	:else immediate
			H @@ 3 + _if_patch @@ ! // Set the jump address of IF to three on.
			$C3 c, 					// JP 
			h @@ _if_patch !!  		// Save jump patch
			0 , 		
	;

	:then immediate 
			h @@ _if_patch @@ !
	;

	:con.pos 	variable
	:con.x   	variable
	:con.y  	variable 
	:con.colour variable

	:con.home 	ab>r 
					0 con.x !! 0 con.y !! $3028 con.pos !! $20 con.colour !! 
				r>ab ;
	:con.ink 
				ab>r 
					a>r con.colour @@ $0F and con.colour !! r>a 16* con.colour +! 
				r>ab ;

	:con.paper 
				ab>r
					a>r con.colour @@ $F0 and con.colour !! r>a con.colour +! 
				r>ab ;

	:con.clear abc>r 
					con.home 
					1024 a>c 
					$3000 $20 fill
					$3400 con.colour @@ fill 
				r>abc ;

	:_con.scroll 
			760 a>c 
			$3028 $3050 copy
			$3428 $3450 copy
			40 a>c
			$3320 $20 fill
			$3720 con.colour @@ fill
			-1 con.y +!
			-40 con.pos +!
	;

	:_con.down 
		1 con.y +! 0 con.x !!
		con.y @@ 20 = if _con.scroll then ;
	;

	:_con.emit 	
					con.pos @ c! 
					con.pos @@ 1024 + con.colour @@ swap c! 
					1 con.pos +! 1 con.x +!
					con.x @@ 40 = if _con.down then 
				;

	:con.cr 
			abc>r
			repeat 
				32 _con.emit 
			con.x @@ 0= until 
			r>abc
	;

	:con.emit 
			abc>r 
			a>r 13 = if 
				r>a con.cr 
			else 
				r>a _con.emit 
			then 
			r>abc 
	;

	:con.print 
			ab>r 
			repeat 
				a>b c@ if con.emit else r>ab ; then
				b>a ++
			forever
	;

	:test 
		con.clear 42 con.emit 0 con.paper 
		43 con.emit 13 con.emit 44 con.emit con.cr 1 con.ink 
		\"Hello_World con.print
		13 con.emit 42 con.emit
		11564 times a>r 15 mod ++ con.ink r>a 255 and con.emit tend
	; 

	[0 4096 c!]
	[test]

""".split("\n")
puts("\t.db\t#{CodeObject.new.process_block(s).to_hex}\n\n")

