
# brainfuck source data
$bf_chars = "><+-.,[]".split(//)
$bf_chars_num = $bf_chars.length

$bf_chars_to_num = Hash.new

i=0

$bf_chars.each do |char|
	$bf_chars_to_num[char] = i
	i+=1
end


# hiragana source data

$hiragana_chars = "あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよわらりるれろをんぁぃぅぇぉゃゅょがぎぐげござじずぜぞだぢづでどばびぶべぼぱぴぷぺぽっ".split(//)

$hiragana_chars_num = $hiragana_chars.length

$hiragana_chars_to_num = Hash.new

i = 0

$hiragana_chars.each do |char|
	$hiragana_chars_to_num[char] = i
	i+=1
end


