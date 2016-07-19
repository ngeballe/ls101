def wrap_statement(statement, vertical_mark, horizontal_mark)
  vertical_wrapper = " #{vertical_mark * (statement - 1)} "
  vertical_wrapper + "#{horizontal_mark}#{statement}#{horizontal_mark}" + vertical_wrapper
  statement
end

def parse_line(line)
  line = line.chomp
  if line == "start"
    puts "  ~   ~  "
    puts "( Start )"
    puts "  ~   ~  "
    puts 
    #puts wrap_statement(line.capitalize, "~", "(")
  end
end

File.open("flowchart.txt") do |f|
  f.each do |line|
    parse_line(line)
  end
end