def capitalize (word)
  if word.length > 10
    return word.upcase
  end
end

puts capitalize("hello world")