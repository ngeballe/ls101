# Question 6

# Starting with the string:

famous_words = "seven years ago..."

# show two different ways to put the expected "Four score and " in front of it.

famous_words = "Four score and " + famous_words
puts famous_words

famous_words = "seven years ago..."
famous_words = "Four score and " << famous_words
puts famous_words