p_outer = 92
q_outer = "I have a question"
r_outer = [82, 45]
s_outer = r_outer[1]

puts "p_outer = #{p_outer} and has an id of: #{p_outer.object_id}" # 92, 185
puts "q_outer = #{q_outer} and has an id of: #{q_outer.object_id}" # id = 70130394847640
puts "r_outer = #{r_outer} and has an id of: #{r_outer.object_id}" # id = 70130394847620
puts "s_outer = #{s_outer} and has an id of: #{s_outer.object_id}" # 45, 91

1.times do
  p_outer_inner 
end

