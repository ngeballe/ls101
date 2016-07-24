# Question 6

# Alyssa was asked to write an implementation of a rolling buffer. Elements are added to the rolling buffer and if the buffer becomes full, then new elements that are added will displace the oldest elements in the buffer.

# She wrote two implementations saying, "Take your pick. Do you like << or + for modifying the buffer?". Is there a difference between the two, other than what operator she chose to use to add an element to the buffer?

def rolling_buffer1(buffer, max_buffer_size, new_element)
  buffer << new_element
  buffer.shift if buffer.size >= max_buffer_size
  buffer
end

def rolling_buffer2(input_array, max_buffer_size, new_element)
  buffer = input_array + [new_element]
  buffer.shift if buffer.size >= max_buffer_size
  buffer
end

people = %w(Alan Betsy Cheng Dawit Ella Federico)
people = rolling_buffer1(people, 6, "Gina")
p people # => ["Betsy", "Cheng", "Dawit", "Elna", "Federico", "Gina"]

people = %w(Alan Betsy Cheng Dawit Ella Federico)
people = rolling_buffer2(people, 6, "Gina")
p people # => ["Betsy", "Cheng", "Dawit", "Elna", "Federico", "Gina"]

# Answer: Both methods work, but I like rolling_buffer1 a little better because it's more streamlined. You just modify the buffer variable, rather than having an input_array parameter and then creating a buffer variable. I believe the << operator is more idiomatic in Ruby.

# Right Answer: Yes, there is a difference. While both methods have the same return value, in the first implementation, the input argument called buffer will be modified and will end up being changed after rolling_buffer1 returns. That is, the caller will have the input array that they pass in be different once the call returns. In the other implementation, rolling_buffer2 will not alter the caller's input argument.

cities = %w(Seattle Orlando Moscow Beijing Rome)
new_cities = rolling_buffer1(cities, 5, "Nairboi")
p new_cities # => %w(Orlando Moscow Beijing Rome Nairobi)
p cities # => %w(Orlando Moscow Beijing Rome Nairobi)

cities = %w(Seattle Orlando Moscow Beijing Rome)
new_cities = rolling_buffer2(cities, 5, "Nairboi")
p new_cities # => %w(Orlando Moscow Beijing Rome Nairobi)
p cities # => %w(Seattle Orlando Moscow Beijing Rome)

