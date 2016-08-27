def change_name(name)
  name = 'bob' # does this reassignment change the object outside the method?
end

name = 'jim'
change_name(name)
puts name # => jim

def cap(str)
  str.capitalize! # does this affect the object outside the method?
end

name = "jim"
cap(name)
puts name # => Jim

def some_method(number)
  number = 7 # this is implicitly returned by the method
end

a = 5
some_method(a)
puts a
