def value_and_id(object)
  "Value: #{object}, ID: #{object.object_id}"
end

def changes_in_value(ary)
  changes = []
  ary.each_with_index do |n, idx|
    if idx < ary.length - 1
      changes << ary[idx + 1] - n
    end
  end
  changes
end

ids = []

string1 = "even"
ids << string1.object_id
puts "string1: #{value_and_id(string1)}"

another_string = "if"
ids << another_string.object_id
puts "another_string: #{value_and_id(another_string)}"

another_string = "john"
p another_string.object_id
ids << another_string.object_id
puts ""

string3 = "they're different"
puts "string3: #{value_and_id(string3)}"
ids << string3.object_id


p ids
p changes_in_value(ids)


