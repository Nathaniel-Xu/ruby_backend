def count_zero (num)
  if num == 0
    puts num
  elsif num < 0
    puts num
    count_zero(num + 1)
  else
    puts num
    count_zero(num-1)
  end
end

count_zero(10)
count_zero(-10)