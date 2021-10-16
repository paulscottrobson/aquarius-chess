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
	@@id = 1000

	def initialize(name,modifiers,body)
		@name = name.upcase.strip
		validate @name
		@body = body 
		@compile_only = modifiers.index("compile") 
		@unique = @@id 
		@@id += 1
	end 

	def render(handle)
		handle.write("; --------------------------------------\n")
		handle.write(";             #{@name}\n")
		handle.write("; --------------------------------------\n")
		handle.write("#{exec_label}:\n")
		open_define(handle)
		handle.write(@body.join("\n")+"\n")
		close_define(handle)
	end

	def exec_label 
		"word_#{@unique}"
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

	def render_dictionary(handle)
		type_byte = @compile_only ? 0x80:0x81
		handle.write("; #{@name}\n")
		handle.write("\t.db\t$#{type_byte.to_s(16)}\n")
		handle.write("\t.dw\t#{exec_label}\n")
		handle.write("\t.db\t#{to_6bit(@name)}\n")		
		@name.length+3
	end

end

class CallingWord < BaseWord
	def open_define(handle)
		handle.write("\tcall\tCompileCallFollowing\n")
	end
end

class CopyingWord < BaseWord
	def open_define(handle)
		handle.write("\tcall\tCopyFollowing\n")
		handle.write("\t.db\tendcopy_#{@unique} - $ - 1\n")
	end 

	def close_define(handle) 		
		handle.write("endcopy_#{@unique}:\n")
	end

end 

class ExecutingWord < BaseWord
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
	# 			Render code
	#
	def render(handle)
		@words.each { |w| w.render(handle) }
		handle.write("\n\n\n")
		handle.write(@support.join("\n"))
	end
	#
	# 			Render dictionary
	#
	def render_dictionary(handle)
		size = 1
		@words.each do |w| 
			size += w.render_dictionary(handle) 
		end
		handle.write("\t.db\t$00\n")
		size
	end
end

voc = Vocabulary.new
Dir.glob('./**/*.def').each { |f| voc.add f }
voc.render(open("vocabulary.asm","w"))
size = voc.render_dictionary(open("dictionary.asm","w"))
open("dictionary.inc","w").write("DictionarySize = #{size}\n")
puts("Dictionary built.")
