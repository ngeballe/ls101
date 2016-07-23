# question7.rb

# Question 7

# Fun with gsub:

def add_eight(number)
  number + 8
end

number = 2

how_deep = "number"
5.times { how_deep.gsub!("number", "add_eight(number)") }

p how_deep # "add_eight(add_eight(add_eight(add_eight(add_eight(number)))))"

# Answer: eval(how_deep) will return 42

puts eval(how_deep)
