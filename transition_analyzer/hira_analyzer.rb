require 'nkf'

p "***** searching for directory *****"

data_dir = "./cards"
kakasi_output_dir = "./kakasi_euc_out"
utf8_file_dir = "./utf8_output"

origin_file_array = Array.new

Dir.foreach(data_dir) do |ent| # ./cards/****
	if ent.to_s[0].chr == "." then
		next
	end
	
	child_dir = data_dir + "/" + ent
	
	if !File.directory? child_dir then
		next
	end

	Dir.foreach(child_dir) do |child_ent| # ./cards/----/****
		unless child_ent == "files" then
			next
		end

		files_dir_path = child_dir + "/" + child_ent

		Dir.foreach(files_dir_path) do |file_ent| #./cards/----/files/****
			if file_ent.to_s[0].chr == "." then
				next
			end

			unless file_ent.include?(".html") then
				next
			end

			child_ent_path = files_dir_path + "/" + file_ent

			origin_file_array << child_ent_path
		end
	end
end


p "Total #{origin_file_array.length} files found"



p "***** kakasi proccessing *****"
p " converting sjis kanji, katakana included text to euc hiragana text"
unless File.exists?(kakasi_output_dir) then
	Dir.mkdir(kakasi_output_dir)
end

origin_file_array.each do |file_to_kakasi|
	filename = File.basename(file_to_kakasi)
	output_file_name = kakasi_output_dir + "/" + filename


	print "kakasi processing : #{file_to_kakasi} > #{output_file_name}"
	system("kakasi -JH -KH -i sjis -o euc < #{file_to_kakasi} > #{output_file_name}")
	print " ... done\n"

end

p "done kakasi : kanji katakana sjis -> hiragana euc converting"



p "***** euc->utf8 converting *****"

unless File.exists?(utf8_file_dir) then
	Dir.mkdir(utf8_file_dir)
end

Dir.foreach(kakasi_output_dir) do |file|
	orig_file_path = kakasi_output_dir + "/" + file
	orig_file_name = File.basename(file)
	if orig_file_name[0].chr == "." then
		next
	end

	utf8_file_path = utf8_file_dir + "/" + orig_file_name
	print "processing #{orig_file_path} -> #{utf8_file_path}"
	
	File.open(orig_file_path) do |eucfile|
		tmp = eucfile.read
		utf8_tmp = NKF.nkf('-w',tmp)
		
		File.open(utf8_file_path,"w") do |utf8_file|
			utf8_file.puts utf8_tmp
		end
	end
	
	print " .. done\n"
end
