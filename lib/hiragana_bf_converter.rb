require "lib/hirafuck_lib"
require "lib/hiragana_bf_sequencer"


class HiraganaBrainfuckConverter
	def initialize(hiragana_data_file_name, bf_data_file_name)
		@hb_seq = HiraganaBrainfuckSequencer.new(hiragana_data_file_name, bf_data_file_name)
	end


	def filter_source_array(array)
		array.map! do |item|
			if $hiragana_chars.include?(item)
				item
			else
				nil
			end
		end
		array.compact!
	end

	# must delete char that is not hiragana here
	def convert(top_function,source_array)
		filter_source_array(source_array)


		source_length = source_array.length
		current_function =top_function
		next_function = nil
		bf_functions = Array.new

		bf_functions << current_function

		0.upto(source_length-2) do |n|
			current_char = source_array[n]
			next_char = source_array[n+1]
			next_function = @hb_seq.next_function(current_char, current_function, next_char)

			if next_function == "+" then
				p "#{source_array[n]} -> #{source_array[n+1]} : +"
			end

			
			bf_functions << next_function
			current_function = next_function
			next_function = nil
		end
		
		return bf_functions.to_s
	end

	def run

	end

end
