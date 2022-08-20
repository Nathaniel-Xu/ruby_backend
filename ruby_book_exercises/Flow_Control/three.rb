def num_split (num)
  if 0 <= num && num <= 50
    return puts "Between 0 and 50"
  elsif 51 <= num && num <= 100
    return puts "Between 51 and 100"
  elsif 100 <= num
    return puts "Greater than 100"
  else
    puts "Out of range"
  end
end 

num_split(52)

#should account for negative numbers