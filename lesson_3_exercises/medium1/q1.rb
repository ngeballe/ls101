# Question 1

# Let's do some "ASCII Art" (a stone-age form of nerd artwork from back in the days before computers had video screens). ## I rememer making ASCII art as a kid

# For this exercise, write a one-line program that creates the following output 10 times, with the subsequent line indented 1 space to the right:

# The Flintstones Rock!
#  The Flintstones Rock!
#   The Flintstones Rock!

# I think this means 10 lines, each indented one more space to the right, not that group of 3 ten times

# (0..10).each { |n| puts "#{' ' * n}The Flintstones Rock!" } # this would do it 11 times
# correction--official answer:
10.times { |n| puts ' ' * n + "The Flintstones Rock!" }

# if they meant 3 10 times
# puts 

# 10.times { (0..2).each { |n| puts "#{' ' * n}The Flintstones Rock!" }}