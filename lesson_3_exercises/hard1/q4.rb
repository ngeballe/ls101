def random_hexadecimal_character
  possiblities = ('0'..'9').to_a + ('a'..'f').to_a
  possiblities.sample
end

def hexadecimal_string(number_of_characters)
  str = ""
  number_of_characters.times { str << random_hexadecimal_character }
  str
end

def generate_uuid
  strings = []
  strings << hexadecimal_string(8)
  3.times { strings << hexadecimal_string(4) }
  strings << hexadecimal_string(12)
  strings.join("-")
end

uuid = generate_uuid
puts uuid