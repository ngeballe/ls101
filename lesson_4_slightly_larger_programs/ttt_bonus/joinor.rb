def joinor(array, delimiter=',', conjunction='or')
  return array[0] if array.size == 1
  return array.join(" #{conjunction} ") if array.size == 2
  last_element = array.pop
  joiner = delimiter.end_with?(' ') ? delimiter : delimiter + ' '
  array.join(joiner) + joiner + conjunction + " #{last_element}"
end

puts joinor([1, 2, 3]) == "1, 2, or 3"
puts joinor([1, 2, 3], '; ') == "1; 2; or 3" # You shouldn't have to add a space; the method should do that for you
puts joinor([1, 2, 3], ', ', 'and') == "1, 2, and 3"

puts joinor([1, 2, 3])
puts joinor([1, 2, 3], '; ')
puts joinor([1, 2, 3], ', ', 'and')
puts joinor([1, 3])
puts joinor([1])

def joinor2(arr, delimiter=', ', word='or')
  arr[-1] = "#{word} #{arr.last}" if arr.size > 1
  arr.size == 2 ? arr.join(' ') : arr.join(delimiter)
end

puts joinor2([1])
puts joinor2([1, 2])
puts joinor2([3, 8, 4], ", ", "yet")