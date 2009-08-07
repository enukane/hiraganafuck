require "hirafuck_lib.rb"
require "rubygems"

class HiraganaBrainfuckSequencer
#private

	def num_to_rank(num)
		rank = num / 10
		return rank
	end

	def rank_to_num(rank)
		base = rank * 10
		range = $bf_chars_num + 1
		from = base
		to = base + range
		return from,to
	end

	def get_rank_of_hiragana(current_char, next_char)
		tuple_list = @hiragana_hash[current_char]
		0.upto($hiragana_chars_num -1 ) do |n|
			if tuple_list[n][0] == next_char then
				num = n
				rank = num_to_rank(num)
				return rank
			end
		end

		raise "get_rank_of_hiragana: unknown char #{next_char}"
	end

	def get_rank_of_function(current_func, next_func)
		tuple_list = @bf_hash[current_func]
		0.upto($bf_chars_num -1) do |n|
			if tuple_list[n][0] == next_func then
				rank = n
				return rank
			end
		end

		raise "get_rank_of_function: unknown func #{next_func}" 
		
	end


	def get_function_at(rank, current_func)
		tuple = @bf_hash[current_func][rank]

		return tuple[0]
	end


	def get_hiragana_at(rank, current_char)
		tuple_list = @hiragana_hash[current_char]
		
		from,to = rank_to_num(rank)
		tuples_at_rank = tuple_list[from..to]

		tuples_at_rank.map! do |item|
			item[0]
		end

		return tuples_at_rank
	end


	def sort_hash_by_value_to_tuple(hash)
		tuple_list = Array.new
		tuple_list = hash.to_a.sort do |a,b|
			# sort by value in descended order
			# if value equals then sort by key
			(b[1] <=> a[1]) * 2 + (a[0] <=> b[0])
		end

		return tuple_list
	end

	def array_to_hash(data_array,hash_keys_array)
		limit = data_array.length
		
		hash = Hash.new

		0.upto(limit - 1) do |n|
			in_hash = Hash.new
			0.upto(limit - 1) do |m|
				in_hash[ (hash_keys_array[m]) ] = data_array[n][m]
			end

			tuple_list = sort_hash_by_value_to_tuple(in_hash)

			hash[ (hash_keys_array[n]) ] = tuple_list
		end

		return hash
	end
#public
	def initialize(hiragana_data_file_name, bf_data_file_name)
		@hiragana_data_file_name = hiragana_data_file_name
		@bf_data_file_name = bf_data_file_name

		hiragana_array = nil
		bf_array = nil

		File.open(@hiragana_data_file_name) do |file|
			tmp = file.read
			hiragana_array = YAML.load(tmp)
		end

		File.open(@bf_data_file_name) do |file|
			tmp = file.read
			bf_array = YAML.load(tmp)
		end

		@hiragana_hash = array_to_hash(hiragana_array,$hiragana_chars)
		@bf_hash = array_to_hash(bf_array, $bf_chars)

	end

	# This function answers that 
	# when current hiragana is current_char that binded to 
	# current_func and next one is next_char, 
	# what function corresponds the next_char.
	def next_function(current_char, current_func, next_char)
		function = nil
		
		hira_rank = get_rank_of_hiragana(current_char, next_char)

		bf_func = get_function_at(hira_rank, current_func) 

		return bf_func 
	end

	def next_chars_from_function(current_char, current_func, next_func)
		chars = nil	
		bf_rank = get_rank_of_function(current_func, next_func)
		chars = get_hiragana_at(bf_rank, current_char)

		return chars 
	end

	def bf_hash_of(func)
		return @bf_hash[func]
	end

	def hira_hash_of(char)
		return @hiragana_hash[char]
	end

end
