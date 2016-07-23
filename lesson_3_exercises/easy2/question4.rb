# Question 4

# Starting with this string:

munsters_description = "The Munsters are creepy in a good way."

# Convert the string in the following ways (code will be executed on original munsters_description above):

# "The munsters are creepy in a good way."
# "tHE mUNSTERS ARE CREEPY IN A GOOD WAY."
# "the munsters are creepy in a good way."
# "THE MUNSTERS ARE CREEPY IN A GOOD WAY."

# Answer:

puts munsters_description.capitalize
puts munsters_description.swapcase
puts munsters_description.downcase
puts munsters_description.upcase

# Official Answer:
# convert, so use bang methods
puts

munsters_description.capitalize!
puts munsters_description

munsters_description = "The Munsters are creepy in a good way."
munsters_description.swapcase!
puts munsters_description

munsters_description.downcase!
puts munsters_description

munsters_description.upcase!
puts munsters_description