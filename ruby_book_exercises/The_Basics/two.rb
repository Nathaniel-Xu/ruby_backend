number = 9876
thousands_place = number/1000
hundreds_place = (number/100) % 10
tens_place = (number/10) % 10
ones_place = number % 10

puts "#{thousands_place.to_s}#{hundreds_place.to_s}#{tens_place.to_s}#{ones_place.to_s}"