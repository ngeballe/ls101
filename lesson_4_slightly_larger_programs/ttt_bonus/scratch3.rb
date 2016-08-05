require 'pry'

i = 0

loop do
  binding.pry
  a ||= 47

  i += 1
  break if i > 3
end 