# Question 2

# Create a hash that expresses the frequency with which each letter occurs in this string:

statement = "The Flintstones Rock"

# ex:

# { "F"=>1, "R"=>1, "T"=>1, "c"=>1, "e"=>2, ... }
letters = statement.split("")
letters.uniq!
letters.keep_if { |letter| letter.match(/[A-Za-z]/) }

letter_frequencies = {}
letters.each do |letter|
  letter_frequencies[letter] = statement.scan(letter).count
end

p letter_frequencies

