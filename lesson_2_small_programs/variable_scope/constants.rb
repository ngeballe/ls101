# constants.rb

USERNAME = 'Batman'

def authenticate
  puts "Logging in #{USERNAME}"
end

authenticate

FAVORITE_COLOR = 'taupe'

1.times do
  puts "I love #{FAVORITE_COLOR}!"
end

loop do
  MY_TEAM = "Phoenix Suns"
  local = "Wizards"
  break
end

puts MY_TEAM
puts local # => NameError
