# underscore_for_unused_parameters.rb

# Suppose you have an array of names, and you want to print out a string for every name in the array, but you don't care about the actual names. In those situations, use an underscore to signify that we don't care about this particular parameter.

names = %w(fred johana bryson jackie)

names.each { |_| puts "got a name!" }
names.each { puts "got a name!" } # why isn't this OK?

names.each_with_index do |_, idx|
  puts "#{idx + 1} got a name!"
end
