Kernel.puts("Please enter a number")
number1 = Kernel.gets().chomp().to_i()
Kernel.puts("Please enter another number")
number2 = Kernel.gets().chomp().to_i()
Kernel.puts("Please choose an operation to perform on the numbers")
OPERATIONS = {add: "+", subtract: "-", multiply: "*", divide: "/"}
OPERATIONS.each do |word, symbol|
  Kernel.puts("Type \"#{symbol}\" to #{word}")
end
operation = Kernel.gets().chomp()

# do the calculation
result = case operation
  when "+"
    number1 + number2
  when "-"
    number1 - number2
  when "*"
    number1 * number2
  when "/"
    number1 / number2
  end

Kernel.puts("#{number1} #{operation} #{number2} = #{result}")
