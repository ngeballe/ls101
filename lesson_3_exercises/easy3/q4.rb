# Question 4

# Shorten this sentence:

advice = "Few things in life are as important as house training your pet dinosaur."

# ...remove everything starting from "house".

# Review the String#slice! documentation, and use that method to make the return value "Few things in life are as important as ". But leave the advice variable as "house training your pet dinosaur.".

slice_value = advice.slice!(/.*important as /)
p slice_value # => "Few things in life are as important as "
p advice # => "house training your pet dinosaur."

# As a bonus, what happens if you use the String#slice method instead?
advice = "Few things in life are as important as house training your pet dinosaur."
slice_value = advice.slice(/.*important as /)
p slice_value # => "Few things in life are as important as "
p advice # => "Few things in life are as important as house training your pet dinosaur."

# Using slice instead of slice! returns the same thing but doesn't shorten the original string

# official answer--this is cleaner
advice.slice!(0, advice.index('house'))

p advice