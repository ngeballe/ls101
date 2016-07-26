x = 80
x = ["a string"]

p x.object_id

def show_id(var)
  var_id = var.object_id
  p var_id
end

show_id(x)


n = 49

def change(n)
  n = 97
end

p n # 49