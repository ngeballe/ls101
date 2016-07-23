# Question 3

# In the age hash:

ages = { "Herman" => 32, "Lily" => 30, "Grandpa" => 402, "Eddie" => 10 }

# throw out the really old people (age 100 or older).

age_discrimination = ages.reject { |name, age| age >= 400 }

p age_discrimination

# official answer:
ages.keep_if { |_, age| age < 100 } # this actually gets rid of the old people permanently

ages = { "Herman" => 32, "Lily" => 30, "Grandpa" => 402, "Eddie" => 10 }
ages.delete_if { |_, age| age >= 100 }
p ages

