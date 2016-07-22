# variable_shadowing.rb

n = 10

[1, 2, 3].each do |n|
  puts n
end

puts n # => 10