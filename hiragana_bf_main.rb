$KCODE="UTF8"
require "lib/hiragana_bf_converter"

hb_converter = HiraganaBrainfuckConverter.new("hira_trans_p.yml", "bf_trans_p.yml")

source_name = ARGV.shift

bf_text = nil

File.open(source_name) do |source_file|
	source_text = source_file.read
	source_array = source_text.split(//)
	top_function = source_array.shift
	p source_array
	bf_text = hb_converter.convert(top_function, source_array)
end

File.open("tmp.bfk","w") do |file|
	file.write bf_text
	file.flush
end


