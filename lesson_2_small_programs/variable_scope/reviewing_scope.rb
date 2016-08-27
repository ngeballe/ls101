s = "Let's go to the store"

names = %w(Sue Tom Heather Jim Kate)

names.each do |name|
  s = name.swapcase
  puts "Hi, #{s}"
  city = "Boston"
end

puts s == "kATE"

puts city rescue puts "Exception because the variable city is local to the block"

age = 47

def say_age
  age = 65
  puts "I'm #{age} years old."
end

puts age == 47
