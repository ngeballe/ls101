# Question 3

# The result of the following statement will be an error:

# puts "the value of 40 + 2 is " + (40 + 2)

# Why is this and what are two possible ways to fix this?

# Answer: It will be an error because (40 + 2) evaluates to an integer 42, and you can't concatenate a string ("the value of 40 + 2 is ") and an integer.

puts "the value of 40 + 2 is #{40 + 2}" # fix 1
puts "the value of 40 + 2 is " + (40 + 2).to_s # fix 2
