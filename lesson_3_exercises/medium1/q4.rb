# Question 4

# What happens when we modify an array while we are iterating over it? What would be output by this code?

numbers = [1, 2, 3, 4]

numbers.each do |number|
  p number
  numbers.shift(1)
end

# The output will be:
# 1
# 3
# It returns [3, 4]
# The problem with modifying an array while iterating over it is that the iteration will skip elements in the array. Calling numbers.shift(1) the first time removes the initial element from the array (1, in this case), but then the next round of iteration starts with the element that is NOW at position 1 in the array (3), rather than the one that was originally at position 1 (2). That's why it prints 3 but not 2. Then after removing 2 from the array with the second numbers.shift(1), the array only has two elements: [3, 4]. At that point, the iterator is looking for the element at position 2 and the array but there no longer is a position 2 since the array has a length of 2. So the loop exits. The moral of the story: don't modify an array while iterating over it; you'll get strange behavior that's probably not what you want.

# What would be output by this code?

numbers = [1, 2, 3, 4]
numbers.each do |number|
  p number
  numbers.pop(1)
end

# 1
# 2
# It returns [1, 2]

# This time, you're removing elements from the end of the array rather than the beginning. So the loop will print 1, then remove the 4 from the end of the array, then print 2, then remove the 3. Now the array is just [1, 2] and there is no element at position 2 in the array (which is what the iterator is looking for), so the program exits the loop.


