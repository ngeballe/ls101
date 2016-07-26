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

w = "This pattern seems to hold with any string, eh?"
ids << w.object_id
puts "w: #{value_and_id(w)}"

x = "This pattern seems to hold with any string, eh?"
ids << x.object_id
puts "x: #{value_and_id(x)}"

z = "This pattern seems to hold with any string, eh?"
puts "z: #{value_and_id(z)}"
ids << z.object_id

y = "This pattern seems to hold with any string, eh?"
puts "y: #{value_and_id(y)}"
ids << y.object_id

k = "This pattern seems to hold with any string, eh?"
puts "k: #{value_and_id(k)}"
ids << k.object_id

_j_pierpont_finch = "This pattern seems to hold with any string, eh?"
puts "_j_pierpont_finch: #{value_and_id(_j_pierpont_finch)}"
ids << _j_pierpont_finch.object_id

__william_of__OranGe = "This pattern seems to hold with any string, eh?"
puts "__william_of__OranGe: #{value_and_id(__william_of__OranGe)}"
ids << __william_of__OranGe.object_id

p ids
p changes_in_value(ids) # [-120, -100, -100, -100, -100, -100]


