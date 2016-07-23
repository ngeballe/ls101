# Question 1

# In this hash of people and their age,

ages = { "Herman" => 32, "Lily" => 30, "Grandpa" => 402, "Eddie" => 10 }

# see if there is an age present for "Spot".

spot_check = ages.has_key?("Spot") # false
puts spot_check

# Bonus: What are two other hash methods that would work just as well for this solution?

ages.include?("Spot")
ages.member?("Spot")

official_answer = ages.key?("Spot")
