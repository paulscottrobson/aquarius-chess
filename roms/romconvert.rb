# *****************************************************************************
# *****************************************************************************
#
#		Name:		definitions.rb
#		Author:		Paul Robson (paul@robsons.org.uk)
#		Date:		30th September 2021
#		Reviewed: 	No
#		Purpose:	Class for substitute definitions.
#
# *****************************************************************************
# *****************************************************************************

# *****************************************************************************
#
#  					Class encapsulating standard ROM
#
# *****************************************************************************

class StandardROM
	def initialize(binary_file)
		@data = open(binary_file,"rb").each_byte.collect { |a| a }
	end 

	def export_include(include_file)
		bytes = @data.collect { |b| b.to_s }.join(",")
		open(include_file,"w").write("{ "+bytes+" }\n")
		self
	end

	def export_binary(binary_file) 
		h = open(binary_file,"wb")
		@data.each { |b| h.write(b.chr) }
		self 
	end
end

# *****************************************************************************
#
#  					Class encapsulating encrypted ROM
#
# *****************************************************************************

class EncodedROM < StandardROM
	def initialize(binary_file)
		super
		decode_rom_image
	end 

	def decode_rom_image
		check_signature_match
		xor = calculate_signature
		@data = @data.collect { |a| a ^ xor }
	end 

	def check_signature_match 	
		decode_table = [43,55,36,36,51,44]
		(0..5).each do |e|
			byte = decode_table[e] - @data[0x200F-e*2]/4
			raise "Not an encrypted ROM " if byte != 15-e*2
		end
	end

	def calculate_signature
		total = 78 
		(3..14).each { |a| total = total + @data[0x2000+a]  }
		(total & 0xFF) ^ @data[0x200F]		
	end

end 

if __FILE__ == $0 
	StandardROM.new("aquarius.chr").export_include("character_rom.h")
	StandardROM.new("aquarius.rom").export_include("kernel_rom.h")
	EncodedROM.new("tron.bin").export_binary("tron.bin.decoded")
	EncodedROM.new("add tarmin.bin").export_binary("add tarmin.bin.decoded")
	EncodedROM.new("utopia.bin").export_binary("utopia.bin.decoded")
end