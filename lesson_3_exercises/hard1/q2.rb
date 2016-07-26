# Question 2

# What is the result of the last line in the code below?

greetings = { a: 'hi' }
informal_greeting = greetings[:a]
informal_greeting << ' there'

puts informal_greeting  #  => "hi there"
puts greetings

# Answer: The result is:
# {:a=>"hi there"}
# because the shovel operator changed the hash