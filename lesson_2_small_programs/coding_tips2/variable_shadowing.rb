name = 'johnson'

['kim', 'joe', 'sam'].each do |name|
  # uh-oh, we cannot access the outer scoped "name"!
  puts "#{name} #{name}"
end

# not variable shadowing

name = 'johnson'

['kim', 'joe', 'sam'].each do |fname|
  name = fname
end

