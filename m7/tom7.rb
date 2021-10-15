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
#  			M7 code object
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
			type = @is_immediate ? 0xA0:0x60 						# $80 immediate $40 compiled $00 definition $C0 comment
			if w[0] == ":"  										# space character.
				type = 0x20
				w = w[1..]
			end
			@code.append(type)
			w = w.each_char.collect {|c| c.ord & 0x3F }				# followed by 6 bit ASCII ending in bit 6 set.
			w[-1] |= 0x40
			w.each do |c|
				c = c.ord 
				@code.append(c)
			end
		end
		self
	end

	def to_hex
		(@code+[0xFF]).collect {|b| "$"+b.to_s(16) }.join(",")  	# $C0 is the end marker, can't use ? in a comment.
	end
end

s = """
//
// 		M7 Source code
//
  :test   [ immediate ] compiled  // later
""".split("\n")
puts("\t.db\t#{CodeObject.new.process_block(s).to_hex}\n\n")

