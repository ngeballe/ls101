# Don't mutate the caller during iteration

# iterating without mutating object or its elemetns -- fine
words = %w(scooby doo on channel two)
words.each { |str| puts str }

# mutating elements within object but not object itself -- fine
words = %w(scooby doo on channel two)
words.each { |str| str << '!' }
puts words.inspect # => ["scooby!", "doo!", "on!", "channel!", "two!"]

# BAD
words = %w(scooby doo on channel two)
words.each { |str| words.delete(str) }
# p words
# words.each do |str|
#   p str
#   words.delete(str)
#   p words
#   puts
# end
puts words.inspect
