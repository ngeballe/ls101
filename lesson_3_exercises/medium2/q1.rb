# q1.rb

munsters = {
  "Herman" => { "age" => 32, "gender" => "male" },
  "Lily" => { "age" => 30, "gender" => "female" },
  "Grandpa" => { "age" => 402, "gender" => "male" },
  "Eddie" => { "age" => 10, "gender" => "male" }
}

# Figure out the total age of just the male members of the family.

total_age_of_males = 0

munsters.each do |_, details|
  if details["gender"] == "male"
    total_age_of_males += details["age"]
  end
end

p total_age_of_males # => 444

