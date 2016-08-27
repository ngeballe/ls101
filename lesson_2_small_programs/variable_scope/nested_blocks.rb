a = 1
b = ''
c = 42.7

loop do
  b = 2
  c = 4

  loop do
    c = 3
    puts a  # 1
    puts b  # 2
    puts c  # 3
    break
  end

  puts a       # 1
  puts b        # 2
  puts c        # error / 3
  break
end

puts a          # 1
puts b          # error / 2
puts c          # error / 3
