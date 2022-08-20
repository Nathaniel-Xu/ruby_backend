hash = {the: "one", thing: "is", this: "moment"}
hash.each_key{|x| puts x}
hash.each_value{|x| puts x}
hash.each{|x,y| puts "#{x}, #{y}" }