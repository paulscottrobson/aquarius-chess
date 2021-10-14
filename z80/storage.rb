# *****************************************************************************
# *****************************************************************************
#
#		Name:		storage.rb
#		Author:		Paul Robson (paul@robsons.org.uk)
#		Date:		1st October 2021
#		Reviewed: 	No
#		Purpose:	Class for substitute definitions.
#
# *****************************************************************************
# *****************************************************************************

require "./definitions.rb"

# *****************************************************************************
#
#  			Store representing 256 mnemonics and code sections
#
# *****************************************************************************

class CodeStore
	def initialize(baseOpcode,dictionary)
		@baseOpcode = baseOpcode
		@dictionary = dictionary
		@mnemonics = {}
		@code = {}
		@cycles = {}
	end 

	def add_one(opcode,code,mnemonic,cycles)
		raise "Wrong code store" if (opcode & 0xFFFFFF00) != @baseOpcode
		opcode = opcode & 0xFF
		raise "Duplicate #{mnemonic} #{opcode}" if @mnemonics.include?(opcode) and (not override)
		@mnemonics[opcode] = mnemonic.downcase
		@code[opcode] = code
		@cycles[opcode] = cycles
		self
	end

	def add(opcode,parts)
		if parts[0].include? "@"
			section = parts[0].match(/(\@[a-zA-Z][a-zA-Z0-9\.]*)/)
			raise "Bad definition "+parts.to_s if not section
			raise "Missing #{section[0]} from both parts" if not parts[1].include? section[0]
			defn = @dictionary.find(section[0][1..])			
			raise "Don't understand #{section[0]}" if not defn
			(0..defn.count-1).each do |n|
				subst = defn.sub(n)
				if subst != nil
					add(opcode+(n << defn.shift),[parts[0].gsub(section[0],subst[0]),parts[1].gsub(section[0],subst[1]),parts[2]])
				end
			end
		else
			raise "Imbalance in @ "+parts.to_s if parts[1].include? "@"
			add_one(opcode,parts[1].gsub("#",""),parts[0].gsub("#",""),parts[2].to_i)
		end
	end

	def mnemonics 
		(0..255).collect { |n| (@mnemonics.include? n) ? '"'+@mnemonics[n].upcase+'"' : '"DB %02X"' % [n] }.join(",")
	end

	def code 
		(0..255).select { |n| @mnemonics.include? n }.collect do |n|
			"case 0x%02x: /**** $%02x:%s ****/\n\t%s;\n\tCYCLES(%d);break;\n" % [n,n,@mnemonics[n].downcase,@code[n],@cycles[n]]
		end.join("\n")		
	end

	def to_s
		(0..255).select {|n| @mnemonics.include? n}.collect { |n| n.to_s(16)+":"+@mnemonics[n]+":"+@code[n] }.join("\n")
	end

	def export
		stub = "_group_%x.h" % [@baseOpcode >> 8]
		header = "//\n//\tThis file is automatically generated\n//\n"
		open("code/_mnemonics"+stub,"w").write(header+mnemonics+"\n\n")
		open("code/_code"+stub,"w").write(header+code+"\n\n")
	end
end

if __FILE__ == $0 
	dc = Dictionary.new.load("defines/_demo.def")	
	cs = CodeStore.new(0,dc)
	cs.add(0x76,["HALT","haltFlag = 1"])
	cs.add(0x06,["LD @tgtreg,$1","@tgtreg = FETCH8()"])
	cs.add(0x80,["@aluop A,@srcreg","ALU_@aluop(@srcreg)"])
	cs.add(0xC6,["@aluop A,$1","ALU_@aluop(FETCH8())"])
	puts cs.mnemonics
	puts cs.code
	cs.export
end



