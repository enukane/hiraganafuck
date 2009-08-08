$KCODE = "UTF8"

require "rubygems"
require "moji"
require 'graphviz'
require '../lib/hirafuck_lib.rb'

data_dir = "../outputs/utf8_output" #

def file_to_hiragana_list(file_path)
	data_array = nil;
	File.open(file_path) do |file|
		data = file.read 
		data_array = data.split("")

		data_array.delete_if do |char|
			if !Moji.type?(char, Moji::ZEN_HIRA) then
				true
			else
				false
			end
		end
	end

	return data_array
end


def count_in_array(array)
	return_array = Array.new($hiragana_chars_num){|i|
		Array.new($hiragana_chars_num) {|i|
			0.0
		}
	}

	if array == nil then
		return return_array
	end
	
	limit = array.length() -1


	0.upto(limit) do |n|
		current_char = array[n]
		next_char = array[n+1]
		
		current_num = $hiragana_chars_to_num[current_char]
		next_num = $hiragana_chars_to_num[next_char]

		if current_num == nil || next_num == nil then
			next
		end
		i = return_array[current_num][next_num]
		i += 1
		return_array[current_num][next_num] = i
	end

	return return_array

end
		
def merge_array(base_array, array_to_add)
	limit = $hiragana_chars_num - 1
	0.upto(limit) do |n|
		0.upto(limit) do |m|
			base_array[n][m] += array_to_add[n][m]
		end
	end
end



def generate_p_array(array)
	p_array = count_in_array(nil)

	limit = $hiragana_chars_num -1
	0.upto(limit) do |n|
		total = 0
		0.upto(limit) do |m|
			total += array[n][m]
		end
		0.upto(limit) do |m|
			if total == 0 then
				p_array[n][m] = 0
			else
				p_array[n][m] = array[n][m] / total
			end
		end
	end

	return p_array
end




p "***** HIRAGANA RIST *****"
p $hiragana_chars_to_num


p "***** Text -> hash in hash *****"

hira_map = count_in_array(nil)

i = 0

Dir.foreach(data_dir) do |entry_name|
	if entry_name[0].chr == "." then
		next
	end

	target_file_path = data_dir + "/" + entry_name
	
	print "processing : #{target_file_path}\n"

	print "array -> hiragana list "
	array = file_to_hiragana_list(target_file_path)
	print "-> counter hash "
	count_array = count_in_array(array)
	print "-> merging hash "
	merge_array(hira_map, count_array)

	p "-> done"
	i+=1
end

p "***** saving counter *****`"
File.open("counter.yml","w") do |file|
	file.write YAML.dump(hira_map)
end



p " ... done"
p " ***** generating probability array *****"
p_array = generate_p_array(hira_map)

p "***** Probability array is like this *****"
p p_array

p "***** YAMLizing map *****"
File.open("hira_trans_p.yml","w") do |file|
	file.write YAML.dump(p_array)
	file.flush
end

p "DONE ALL #{i} files"
