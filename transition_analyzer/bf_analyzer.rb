require "rubygems"

$bf_chars = "><+-.,[]".split(//)
$data_dir = "./bfsource"
$bf_chars_num = $bf_chars.length

$bf_chars_to_num = Hash.new

i=0

$bf_chars.each do |char|
	$bf_chars_to_num[char] = i
	i+=1
end



def extract_bf_chars(source_string)
	array = Array.new
	
	source_array = source_string.split(//)

	source_array.each do |char|
		if $bf_chars.include?(char) then
			array << char
		end
	end

	return array
end


def count_in_array(array)
	map = Array.new($bf_chars_num) {|i|
		Array.new($bf_chars_num) {|i|
			0.0
		}
	}

	if array == nil then
		return map
	end

	limit = array.length() -1
	0.upto(limit) do |n|
		current_char = array[n]
		next_char = array[n+1]

		current_num = $bf_chars_to_num[current_char]
		next_num = $bf_chars_to_num[next_char]

		if current_num == nil || next_num == nil then
			next
		end

		i = map[current_num][next_num]
		i += 1
		map[current_num][next_num] = i
	end
	
	return map

end

def merge_map(base_map, delta_map, num)
	limit = num - 1
	0.upto(limit) do |n|
		0.upto(limit) do |m|
			base_map[n][m] += delta_map[n][m]
		end
	end
end

def generate_p_map(trans_map, num)
	p_map = count_in_array(nil)


	limit = num -1

	0.upto(limit) do |n|
		total = 0
		0.upto(limit) do |m|
			total += trans_map[n][m]
		end
		0.upto(limit) do |m|
			if total == 0 then
				p_map[n][m] = 0
			else
				p_map[n][m] = trans_map[n][m] / total
			end
		end
	end

	return p_map

end


p "***** Searching for sample files *****"

bf_map = count_in_array(nil)

Dir.foreach($data_dir) do |ent|
	if ent.to_s[0].chr == "." then
		next
	end

	ent_path = $data_dir + "/" + ent

	File.open(ent_path) do |file|
		p "***** Processing #{ent_path} *****"

		source = file.read
		print "source -> only bf array "
		array = extract_bf_chars(source) 
		print "-> map "
		map = count_in_array(array)
		print "-> merging map "
		merge_map(bf_map, map,$bf_chars_num)	
		print "-> done\n"
	end
end

p "***** transition map *****"
File.open("bf_transition.yml","w") do |file|
	file.write YAML.dump(bf_map)
end

p " ... done"
p "***** Probability map generating *****"
p_map = generate_p_map(bf_map,$bf_chars_num)

p "***** Probability map is like this *****"
p p_map

p "***** YAMLizing map *****"
File.open("bf_trans_p.yml","w") do |file|
	file.write YAML.dump(p_map)
	file.flush
end

p "DONE ALL"


