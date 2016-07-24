# Question 3

# In an earlier exercise we saw that depending on variables to be modified by called methods can be tricky:

def tricky_method(a_string_param, an_array_param)
  a_string_param += "rutabaga"
  an_array_param << "rutabaga"
end

my_string = "pumpkins"
my_array = ["pumpkins"]
tricky_method(my_string, my_array)

puts "My string looks like this now: #{my_string}" # => My string looks like this now: pumpkins
puts "My array looks like this now: #{my_array}" # => My array looks like this now: ["pumpkins", "rutabaga"]

#def update_string

# We learned that whether the above "coincidentally" does what we think we wanted "depends" upon what is going on inside the method.

# How can we refactor this exercise to make the result easier to predict and easier for the next programmer to maintain?

# Answer: I'm a little confused by this question. Renaming the method and eliminating the superfluous first line in it--and eliminating the string_param parameter--would refactor the code to get the same result in a way that's more clear. But I don't think that's what you mean.

def add_rutabaga_to_array(an_array_param)
  an_array_param << "rutabaga"
end

my_string = "pumpkins"
my_array = ["pumpkins"]
add_rutabaga_to_array(my_array)

puts "My string looks like this now: #{my_string}" # => My string looks like this now: pumpkins
puts "My array looks like this now: #{my_array}" # => My array looks like this now: ["pumpkins", "rutabaga"]

# some other methods
puts "\nOther Methods\n\n"

# These modify the orginal object:

def add_rutabaga_to_string(str)
  str << "rutabaga"
end

s = "carrot and "
add_rutabaga_to_string(s)
p s # => "carrot and rutabaga"

def add_rutabaga_to_string_and_array(str, ary)
  str << "rutabaga"
  ary << "rutabaga"
end

my_string = "string"
my_array = ["first element"]
add_rutabaga_to_string_and_array(my_string, my_array)

p my_string # "stringrutabaga"
p my_array # ["first element", "rutabaga"]

# ... whereas these methods don't modify the original object:

def string_with_rutabaga(str)
  str += "rutabaga"
end

string1 = "apple"
string2 = string_with_rutabaga(string1) 
p string2 # => "applerutabaga"
p string1 # => "apple"

def array_with_rutabaga(ary)
  ary += ["rutabaga"]
end

array1 = ["Clinton", "Trump"]
array2 = array_with_rutabaga(array1)
p array2 # => ["Clinton", "Trump", "rutabaga"]
p array1 # => ["Clinton", "Trump"]


# The right answer:

def not_so_tricky_method(a_string_param, an_array_param)
  a_string_param += "rutabaga"
  an_array_param += ["rutabaga"]

  return a_string_param, an_array_param
end

my_string = "pumpkins"
my_array = ["pumpkins"]
my_string, my_array = not_so_tricky_method(my_string, my_array)

puts "My string looks like this now: #{my_string}"
puts "My array looks like this now: #{my_array}"