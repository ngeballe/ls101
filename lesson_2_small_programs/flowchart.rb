OPTIONS = "Type 1) start 2) processing 3) input/output 4) decision 5) connector"
puts OPTIONS
command = gets.chomp

flowchart = []

case command
when "1"
#   result = <<DOC

# DOC
  puts " ~~~~~ "
  puts "(Start)"
  puts " ~~~~~ "
when "2"
  puts "Processing"
when "3"
  puts "I/O"
end

