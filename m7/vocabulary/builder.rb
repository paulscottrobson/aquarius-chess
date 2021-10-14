# ***************************************************************************************
# ***************************************************************************************
#
#		Name : 		builder.rb
#		Author :	Paul Robson (paul@robsons.org.uk)
#		Date : 		14th October 2021
#		Purpose :	Builds vocabulary
#
# ***************************************************************************************
# ***************************************************************************************

class BaseWord 
	def initialize(name,modifiers,body)
		@name = name.upcase.strip
		validate @name
		@body = body 
		@compile_only = modifiers.index("compile") 
	end 

	def render(handle,this_link,last_link,unique_id)
		@unique = unique_id
		type_byte = type + (@compile_only ? 0x80 : 0x00)
		handle.write("#{this_link}:\n")
		handle.write("; --------------------------------------\n")
		handle.write(";             #{@name}\n")
		handle.write("; --------------------------------------\n")
		handle.write(" .dw #{last_link}\n")
		handle.write(" .db $#{type_byte.to_s(16)}\n")
		handle.write(" .db #{to_6bit(@name)}\n")
		open_define(handle)
		handle.write(@body.join("\n")+"\n")
		close_define(handle)
	end

	def validate(n) 
		n.each_char do |c|
			raise "Bad name #{name}" if c.ord < 32 or c.ord > 96
		end
	end

	def to_6bit(n)
		n = n.each_char.collect { |a| (a.ord & 0x3F) }		
		n[-1] |= 0x80
		n.collect { |a| "$"+a.to_s(16) }.join(",")
	end

	def open_define(handle)
	end 

	def close_define(handle) 		
	end
end

class CallingWord < BaseWord
	def type 
		0 end
	def open_define(handle)
		handle.write(" call CompileCallFollowing\n")
	end
end

class CopyingWord < BaseWord
	def type 
		1 end
	def open_define(handle)
		handle.write(" call CopyFollowing\n")
		handle.write(" .db endcopy_#{@unique} - * - 1\n")
	end 

	def close_define(handle) 		
		handle.write("endcopy_#{@unique}:\n")
	end

end 

class ExecutingWord < BaseWord
	def type 
		2 end
end

# ***************************************************************************************
#
# 						Class representing the Vocabulary
#
# ***************************************************************************************

class Vocabulary 
	def initialize
		@words = [] 											# Defined words.
		@support = [] 											# Support code in the files.
	end 
	#
	# 			Add file
	#
	def add(file_name)
		src = open(file_name).select { |a| a.index(";") ? a[..a.index(";")-1] : a  }.collect { |a| a.gsub("\t"," ").rstrip+"||" }.select { |a| a.strip != "" && a[0] != ';' }
		src.join("").split("@end") do |l|
			l = l[1..] while l[0] == '|'
			l = l.split("||")
			if l.length > 0
				if l[0][0] == '@'
					@words.append(create_word(l[0],l[1..]))
				else 
					@support += l
				end
			end
		end
		#puts("===")
		#puts(@words)
	end

	def create_word(header,body)
		m = header.match(/^\@copies\s+(\S+)(.*)$/)
		return CopyingWord.new(m[1],m[2],body) if m
		m = header.match(/^\@calls\s+(\S+)(.*)$/)
		return CallingWord.new(m[1],m[2],body) if m
		m = header.match(/^\@executes\s+(\S+)(.*)$/)
		return ExecutingWord.new(m[1],m[2],body) if m
		raise "Can't process header #{header}"
	end
	#
	# 			Render
	#
	def render(handle)
		handle.write(@support.join("\n"))
		handle.write("\n\n\n")
		last_link = "0"
		link_count = 0
		@words.each do |w|
			this_link = "link#{link_count}"
			last_link = w.render(handle,this_link,last_link,link_count)
			last_link = this_link
			link_count += 1
		end
	end
end

voc = Vocabulary.new
Dir.glob('./**/*.def').each { |f| voc.add f }
voc.render(open("vocabulary.asm","w"))
puts("Vocabulary rendered")
