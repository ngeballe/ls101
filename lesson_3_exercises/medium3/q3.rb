# Question 3

# Let's call a method, and pass both a string and an array as parameters and see how even though they are treated in the same way by Ruby, the results can be different.

# Study the following code and state what will be displayed...and why:

def tricky_method(a_string_param, an_array_param)
  a_string_param += "rutabaga"
  an_array_param << "rutabaga"
end

my_string = "pumpkins"
my_array = ["pumpkins"]
tricky_method(my_string, my_array)

puts "My string looks like this now: #{my_string}"
puts "My array looks like this now: #{my_array}"

# This code is the same as for Medium 2, Q3. Was this one supposed to come first? That one refers to "In an earlier exercise we saw that depending on variables to be modified by called methods can be tricky:"

# Answer: The method mutates the array passed to it since it appends "rutabaga" to the array with the "<<" operator. But it does not mutate the string passed to it. It will display: 
# My string looks like this now: pumpkins
# My array looks like this now ["pumpkins", "rutabaga"]