$KCODE = "UTF8"
require "moji"
require "lib/hiragana_bf_sequencer"

source_array = Array.new

p "********** HIRAGANA-FUCK EDITOR **********"

p "***** First hiragana binding *****"

p "Enter first hiragana"
print "> "
init_hiragana = gets.chop
until Moji::type?(init_hiragana,Moji::ZEN_HIRA) do
	init_hiragana = gets.chop
end
p "ok : first hiragana is #{init_hiragana}"

"Enter first function"
print "> "
init_function = gets.chop
until $bf_chars.include?(init_function)
	init_function = gets.chop
end
p "ok : first function is #{init_function}"

p "first binding is #{init_hiragana} <=> #{init_function}"


p "***** Continuous hiragana binding *****"
flag = true
current_char = init_hiragana
current_function = init_function

source_array << current_function << current_char

hbs = HiraganaBrainfuckSequencer.new("hira_trans_p.yml", "bf_trans_p.yml")

while flag do
	print "\n\n\n"
	p "current bindings : [#{current_char} => #{current_function}]"
	p "whole source : #{source_array.to_s}"
	p "next #{current_function} is binded to #{hbs.next_chars_from_function(current_char,current_function, current_function)}"

	 p "enter command or hiragana"
	 print "> "
	 command = gets.chop
	
	 case command
	 when "help"
		 p "-- command list --"
		 p " \"hira\" > show which of the function will be binded to specified hiragana"
		 p " \"func\" > show list of hiraganas that will be binded to specified function"
		 p " \"save\" > save current sources to specified file"
		 p " hiragana > add hiragana to sources tail"
		 p "------------------"
	 when "hira"
		 p "Enter hiragana"
		 print "> "
		 hiragana = gets.chop
		 unless Moji::type?(hiragana, Moji::ZEN_HIRA) then
			 p "character you entered is not hiragana"
			 break
		 end 
		 next_function = hbs.next_function(current_char, current_function, hiragana)
		 p "next function is : #{next_function}"
	 when "func"
		 p "Enter function"
		 print "> "
		 function = gets.chop
		 unless $bf_chars.include?(function) then
			 p "function you entered is not function"
			 break
		 end
		 next_hiragana_list = hbs.next_chars_from_function(current_char, current_function,function)
		 p "next hiragana is : #{next_hiragana_list}"
	 when "save"
		 p "Enter filename to save"
		 print "> "
		 file_name = gets.chop
		 File.open(file_name,"w") do |file|
			 tmp = source_array.to_s
			 file.write tmp
			 file.flush
		 end
		 p "Source written to file"
	 when "exit"
		 p "exiting"
		 flag = false
		 break
	 else # hiragana or other unsupported command
		 unless Moji::type?(command, Moji::ZEN_HIRA) then
		 	p "character you entered is not hiragana"
			break
		 end
		 # in case of hiragana
		 source_array << command
		 p source_array
		 next_function = hbs.next_function(current_char,current_function, command)
			
		 current_function = next_function
		 current_char = command
	 end
	 p ""
end


p "exiting editor"





