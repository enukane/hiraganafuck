require "rubygems"
require "graphviz"

p "hello"

$bf_chars = ["for", 'back','inc','dec','print','input','jumpfor','jumpback']
#"\>\<\+\-\.\,\[\]".split(//)
$bf_chars_num = $bf_chars.length

$bf_chars_to_num = Hash.new

i=0

$bf_chars.each do |char|
	$bf_chars_to_num[char] = i
	i+=1
end

p_map = Array.new

File.open("./bf_trans_p.yml") do |file|
	tmp_str = file.read
	p_map = YAML.load(tmp_str)
end

p $bf_chars_to_num


node_hash = Hash.new

GraphViz::new("G",
							{
	:type => "digraph",
	:use => "dot",
	:output => "png",
	:charset => "utf8",
	:file => "bf.png",
	:rankdir => "LR"
	
}){|g|
	g.node[:fontname] = "osaka"
	g.node[:style] = "filled"
	g.edge[:fontname] = "osaka"

	limit = $bf_chars_num -1

	$bf_chars.each do |char|
		n = $bf_chars_to_num[char]
		origin = nil
		if node_hash.has_key?(char) then
			origin = node_hash[char]
		else
			origin = g.add_node(char)
			node_hash[char] = origin
		end
		0.upto(limit) do |m|
			target_char = $bf_chars[m]
			target = nil
			if node_hash.has_key?(target_char) then
				target = node_hash[target_char] 
			else
				target = g.add_node(target_char)
				node_hash[target_char] = target
			end
			g.add_edge(origin, target, :label => p_map[n][m].to_s)
		end
	end
}.output()
