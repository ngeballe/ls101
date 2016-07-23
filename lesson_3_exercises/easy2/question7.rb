# question7.rb

# Question 7

# See if the name "Dino" appears in the string below:

advice = "Few things in life are as important as house training your pet dinosaur."

if advice =~ /Dino/
  contains_dino = true
else
  contains_dino = false
end

p contains_dino