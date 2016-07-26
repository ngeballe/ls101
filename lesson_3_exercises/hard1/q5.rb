# Original method:

# def dot_separated_ip_address?(input_string)
#   dot_separated_words = input_string.split(".")
#   while dot_separated_words.size > 0 do
#     word = dot_separated_words.pop
#     break if !is_a_number?(word)
#   end
#   return true
# end

def is_a_number?(word)
  /^\d+$/.match(word)
end

def dot_separated_ip_address?(input_string)
  dot_separated_words = input_string.split(".")
  return false unless dot_separated_words.length == 4
  while dot_separated_words.size > 0 do
    word = dot_separated_words.pop
    return false if !is_a_number?(word)
  end
  return true
end

puts dot_separated_ip_address?("4.5.5") == false
puts dot_separated_ip_address?("1.2.3.4.5") == false
puts dot_separated_ip_address?("1.3.85.27") == true
puts dot_separated_ip_address?("101.347.5.2") == true