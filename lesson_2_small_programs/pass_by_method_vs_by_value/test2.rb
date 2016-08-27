# Example of a method that modifies its argument permanently
# mutate.rb

a = [1, 2, 3]

def mutate(array)
  array.pop
end

p "Before mutate method: #{a}"
mutate(a)
p "After mutate method: #{a}"

def add_item(arr, item)
  arr << item
end

items = [3, "tom", "jen"]
add_item(items, :q)
p items

def add_item_non_destructively(arr, item)
  arr + [item]
end

people = %w(ron jimmy michelle kat hoa)
result  = add_item_non_destructively(people, "fred")
p result # => ["ron", "jimmy", "michelle", "kat", "hoa", "fred"]
p people # => ["ron", "jimmy", "michelle", "kat", "hoa"]
