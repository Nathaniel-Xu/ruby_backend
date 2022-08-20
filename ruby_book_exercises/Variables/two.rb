puts "How old are you?"
age = gets.chomp.to_i
decades = ["10", "20", "30", "40"]
decades.each do |time|
  age += 10
  puts "In #{time} years you will be: "
  puts age
end