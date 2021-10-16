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
		if w == "[" or w == "]"
			@is_immediate = (w == "[")
		else
			type = @is_immediate ? 0x80:0x40 						# $80 immediate $40 compiled $C0 definition $00 comment
			if w[0] == ":"  														# : prefixed is a red definition.
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
	:add5 5 + ; [ 10 add5 add5 A>C H A>B @ ]
""".split("\n")
puts("\t.db\t#{CodeObject.new.process_block(s).to_hex}\n\n")

