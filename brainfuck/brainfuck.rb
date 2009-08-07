require "brainfuckproc"
require "../lib/dprint.rb"

class BrainFuck
	def initialize(src_name)
		@src_name = src_name
		@bfpProc = BrainFuckProc.new()
	end

	def run
		File.open(@src_name) do |file|
			run_bfp(file)			
		end
	end

	def run_bfp io
		while ch = io.read(1) do
			case ch
			when ">":
				@bfpProc.inc_pointer
			when "<":
				@bfpProc.dec_pointer
			when "+":
				@bfpProc.inc_current_value
			when "-":
				@bfpProc.dec_current_value
			when ".":
				@bfpProc.print_current_value_char
			when ",":
				@bfpProc.get_char_to_current_pos
			when "[":
				jump_forward(io)
			when "]":
				jump_backward(io)
			when "*":
				@bfpProc.print_all_tape
			end
		end
	end

	def jump_forward(io)
		dprint "jump forward:"
		if !@bfpProc.is_zero? then
			dprint "no jump\n"
			return	
		end

		dprint "jump\n"
				
		stack_count = 0;
				
		while true do
			inner_ch = io.read(1)
			
			if inner_ch == "" then # no matched clauses
				puts "ERROR - no matched clauses"
				exit
			end

			if inner_ch == "[" then
				stack_count += 1
			end

			if inner_ch == "]" then
				if stack_count > 0 then
					stack_count -= 1
					next
				else # stack_count == 0 -> matched found
					io.pos += 1
					break # ends here
				end
			end
		end

	end

	def jump_backward(io)
		dprint "jump backward:"
		if @bfpProc.is_zero? then
			dprint "no jump\n"
			return
		end

		dprint "jump\n"

		stack_count = 0;

		if io.pos < 2 then 
			puts "ERROR - guess only ] appears first?"
			exit
		end


		while io.pos > -1 do
			io.pos -= 2

			inner_ch = io.read(1)
			
			if inner_ch == "" then # no more backwards
				puts "ERROR - no match clauses"
				exit
			end

			if inner_ch == "]" then
				stack_count += 1
			end
			
			if inner_ch == "[" then
				if stack_count > 0 then
					stack_count -= 1
					next
				else##matching
					#io.pos += 1
					break
				end
			end

		end

	end

end
