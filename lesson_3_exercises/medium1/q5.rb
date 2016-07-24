# Question 5

# Alan wrote the following method, which was intended to show all of the factors of the input number:

# def factors(number)
#   dividend = number
#   divisors = []
#   begin
#     divisors << number / dividend if number % dividend == 0
#     dividend -= 1
#   end until dividend == 0
#   divisors
# end

# Alyssa noticed that this will fail if you call this with an input of 0 or a negative number and asked Alan to change the loop. How can you change the loop construct (instead of using begin/end/until) to make this work? Note that we're not looking to find the factors for 0 or negative numbers, but we just want to handle it gracefully instead of raising an exception or going into an infinite loop.

def factors(number)
  dividend = number
  divisors = []
  while dividend > 0
    divisors << number / dividend if number % dividend == 0
    dividend -= 1
  end
  divisors
end

p factors(128) # => [1, 2, 4, 8, 16, 32, 64, 128]
p factors(981) # => [1, 3, 9, 109, 327, 981]
p factors(0) # => []
p factors(-12) # => []

# Bonus 1

# What is the purpose of the number % dividend == 0 ?

# Answer: The purpose is to make sure the divisor is actually a factor--that is, that it's an integer that multiplied by another integer equals the original number. Without the "if number % divident == 0" clause, divisors would get added to the array that the method returns even if they're not factors.

# Bonus 2

# What is the purpose of the second-to-last line in the method (the divisors before the method's end)?

# Answer: The purpose is to make the method return the array of divisors (since it's the last expression evaluated in the method)