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
#  									M7 code object
#
# ***************************************************************************************

class CodeObject
	def initialize
		@code = []
		@required = {}
		@is_immediate = false
	end 

	def process_block(b)
		b.each { |l| process_line(l.strip) }
		self
	end 

	def process_line(l)
		if l[0..6] == "require"
			l[7..].strip().split(",").each do |r|
				unless @required.key? r
					puts("\tRequired '#{r}'")
					process_block(open("system/#{r}.m7")) 
					@required[r] = true
				end
			end			
		else
			if l[0..1] != "//"
				(l.index("//") ? l[..l.index("//")-1] : l).upcase.split.each { |w| process_word(w) }
			end
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

	def write_binary(handle)
		(@code+[0x00]).each { |b| handle.write(b.chr) }
	end
end

#puts("\t.db\t#{CodeObject.new.process_block(s).to_hex}\n\n")
code = CodeObject.new 
ARGV.each do |f| 
	puts("Loading '#{f}'")
	code.process_block(open(f)) 
end
code.write_binary(open("m7source.bin","wb"))
