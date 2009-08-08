$KCODE = "UTF8"

require "rubygems"
require "moji"
require "graphviz"
require "../lib/hirafuck_lib"


p_array = Array.new

File.open("../hira_trans_p.yml") do |file|
	tmp_str = file.read
	p_array = YAML.load(tmp_str)
end

GraphViz::new("G", 
							{
	:type => "digraph",
	:use => "dot",
	:output => "png",
	:charset => "utf8",
	:file => "hiragana.png"
}){|g|
	g.node[:fontname] = "osaka"
	g.node[:style] = "filled"
	g.edge[:fontname] = "osaka"

	limit = $hiragana_chars_num - 1

	$hiragana_chars.each do |char|
		n = $hiragana_chars_to_num[char]
		origin = g.add_node(char)	
		0.upto(limit) do |m|
			target_char = $hiragana_chars[m]
			target = g.add_node(target_char)
			if p_array[n][m] > 0.01 then
				g.add_edge(origin, target, :label => p_array[n][m].to_s )
			end
		end
	end
}.output()
