$KCODE = "UTF8"

require "rubygems"
require "moji"
require "graphviz"


$hiraganas = "あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよわをんぁぃぅぇぉゃゅょがぎぐげござじずぜぞだぢづでどばびぶべぼぱぴぷぺぽっ".split(//)


$hira_to_num = Hash.new

i = 0

$hiraganas.each do |char|
	$hira_to_num[char] = i
	i+=1
end

$hiragana_num = $hiraganas.length

p_array = Array.new

File.open("./hiragana_map") do |file|
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

	limit = $hiragana_num - 1

	$hiraganas.each do |char|
		n = $hira_to_num[char]
		origin = g.add_node(char)	
		0.upto(limit) do |m|
			target_char = $hiraganas[m]
			target = g.add_node(target_char)
			if p_array[n][m] > 0.01 then
				g.add_edge(origin, target, :label => p_array[n][m].to_s )
			end
		end
	end
}.output()
