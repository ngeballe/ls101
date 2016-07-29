first = "B"

loop do
  if first == "A"
    puts "AAAA"
    puts "BBBB"
  else
    puts "BBBB"
    puts "AAAA"
  end

  puts "Press q to quit, any other key to continue"
  break if gets.chomp == "q"
end