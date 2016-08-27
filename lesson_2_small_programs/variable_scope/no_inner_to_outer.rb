loop do       # the block creates an inner scope
  c = 1
  break
end

puts c       # => NameError: undefined local variable or method `b' for main:Objectno_inner_to_outer.rb
