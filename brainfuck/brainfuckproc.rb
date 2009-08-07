require "../lib/dprint.rb"

class BrainFuckProc
	def initialize
		@tape = Array.new
		@current_position = 0
	end

	def inc_pointer
		dprint "up #{@current_position}->#{@current_position + 1}"
		@current_position += 1
	end
	def dec_pointer
		dprint "down #{@current_position}->#{@current_position -1}"
		if @current_position == 0 then
			puts "ERROR - pointer lower limit"
			exit
		end
		@current_position -= 1
	end

	def inc_current_value
		if @tape[@current_position] == nil then
			@tape[@current_position] = 0
		end
		@tape[@current_position] += 1
		dprint @tape
	end

	def dec_current_value
		if @tape[@current_position] == nil || @tape[@current_position] == 0 then
			puts "ERROR - value at the pointer is 0"	
			exit
		end

		@tape[@current_position] -= 1
		dprint @tape
	end

	def print_current_value_char
		print @tape[@current_position].chr
	end

	def get_char_to_current_pos
		data = gets
		@tape[@current_position] = data[0]
	end

	def is_zero?
		if @tape[@current_position] == 0 || @tape[@current_position] == nil then
			return true
		else
			return false
		end
	end

	def jump_forward?
		jump?	
	end

	def jump_backward?
		jump?
	end

	def print_all_tape
		data = ""
		@tape.each do |val|
			if val then
				data.concat(val.chr)
			end
		end
		p "ALLDATA:#{data}"
	end

end
