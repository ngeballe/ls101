a = []
100_000.times { a << rand * 130 - 30 } # add 100,000 random nsumbers between -30 and 130

a.each do |n|
  include_n = (10..100).include?(n) 
  cover_n = (10..100).cover?(n)
  if cover_n && !include_n
    puts "Covers but doesn't include #{n}"
    break
  elsif include_n && !cover_n
    puts "Includes but doesn't cover #{n}"
    break
  end
end

range1 = ('a'..'z')
puts range1.include?('jj') # false
puts range1.cover?('jj') # true

range2 = (1776..2016)
puts range2.include?(1952.8) # true
puts range2.cover?(1952.8) # true




