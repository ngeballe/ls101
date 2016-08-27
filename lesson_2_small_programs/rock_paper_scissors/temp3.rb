def add_jr(name)
  # name += ", Jr." # doesn't mutate caller--this creates a new name variable
  puts "Adding Jr...."
  name << ", Jr." # does mutate caller
end

john = "John Smith"
puts john
add_jr(john)
puts john

# def add_one(n)
#   n += 1
# end

# x = 28
# add_one(x)
# puts x

# bill_wins = 0
# add_one(bill_wins)
# puts bill_wins
