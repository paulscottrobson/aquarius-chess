# *****************************************************************************
# *****************************************************************************
#
#		Name:		generate.rb
#		Author:		Paul Robson (paul@robsons.org.uk)
#		Date:		30th September 2021
#		Reviewed: 	No
#		Purpose:	Generate include files
#
# *****************************************************************************
# *****************************************************************************

require 'pathname'
require '../roms/romconvert.rb'

# *****************************************************************************
#
# 	 								File Objects
#
# *****************************************************************************

class FileObject
	def initialize(path)
		@file_name = Pathname(path)
		#puts "#{full_path} #{file_owner} #{is_rom}"
	end

	def full_path
		@file_name.to_s end
	def file_owner
		owner = @file_name.basename.to_s.split("_")[0].split(".")[0].downcase end
	def is_rom 
		@file_name.extname == ".bin"
	end
	def to_s 
		@file_name.basename
	end
end

class RomImage < FileObject
	def export 
		rom = EncodedROM.new(full_path)
		rom.export_binary(file_owner+".cqc")
	end
end

class CassetteFile < FileObject
end

class CassetteGroup
	def initialize
		@bas_root = nil 
		@files = []
	end 
	#
	def add(f)
		if f.full_path.downcase.include?("_bas.")
			raise "Duplicate bas for "+f.full_path if @bas_root
			@bas_root = f
		else
			@files.append(f)
		end
	end
	#
	def export
		if @bas_root 
			files = [@bas_root] + @files 
		else
			files = @files
		end
		h = open(files[0].file_owner+".cqc","wb")
		files.each do |f|
			data = open(f.full_path,"rb").each_byte.collect { |a| a }
			data.each { |b| h.write(b.chr) }
		end
		h.close
	end
	#
	def to_s 
		files = @files.collect { |f| f.to_s }.join(",")
		@bas_root.to_s + " : " + files
	end
end 

#
# 		Get all files
#
file_list = []
Dir.glob('../virtualaquarius/rom/**/*.bin').each { |f| file_list.append(RomImage.new(f))}
Dir.glob('../virtualaquarius/cassette/**/*.caq').each { |f| file_list.append(CassetteFile.new(f))}
Dir.glob('../virtualaquarius/cassette/**/*.CAQ').each { |f| file_list.append(CassetteFile.new(f))}
#
# 		Identify those with dodgy names
#
puts "Bad : #{file_list.select {|l| l.file_owner.length > 6 }.collect { |a| a.to_s}.join(",")}"
file_list = file_list.select { |l| l.file_owner.length <= 6 }
#
# 		Do all the ROMs
#
file_list.select { |f| f.is_rom }.each { |f| f.export }
#
# 		Build group cassette objects
#
cassette_groups = {}
file_list.select { |f| not f.is_rom }.each do |f|
	key = f.file_owner 
	cassette_groups[key] = CassetteGroup.new unless cassette_groups.include? key
	cassette_groups[key].add(f)
end
cassette_groups.each { |k,v| v.export }
