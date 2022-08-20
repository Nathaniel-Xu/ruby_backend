def check_lab (word)
  if word =~ /lab/ 
    puts "Has lab"
  else
    puts "No Lab"
  end
end
check_lab("laboratory")
check_lab("experiment")
check_lab("Pans Labyrinth")
check_lab("elaborate")
check_lab("polar bear")