require 'yaml'

MESSAGES = YAML.load_file('calculator_messages.yml')
LANGUAGE = 'en'

def messages(message, lang = 'en')
  MESSAGES[lang][message]
end

def prompt(key)
  message = messages(key, LANGUAGE)
  message ||= key # if no message found in the hash, display the original key
  Kernel.puts("=> #{message}")
end

def valid_number?(num)
  /\A\d*\.?\d*\z/ =~ num && num =~ /\d/
end

def operator_to_message(op)
  case op
  when "1"
    "Adding"
  when "2"
    "Subtracting"
  when "3"
    "Multiplying"
  when "4"
    "Dividing"
  end
end

prompt('welcome')

name = ''
loop do
  name = Kernel.gets().chomp()
  if name.empty?
    prompt(messages('valid_name'))
  else
    break
  end
end

prompt("Hi, #{name}!")

loop do # main loop
  number1 = ''
  loop do
    prompt(messages('first_number'))
    number1 = Kernel.gets().chomp()

    if valid_number?(number1)
      break
    else
      prompt(messages('valid_number'))
    end
  end

  number2 = ''
  loop do
    prompt(messages('second_number'))
    number2 = Kernel.gets().chomp()

    if valid_number?(number2)
      break
    else
      prompt(messages('valid_number'))
    end
  end

  operator_prompt = <<-MSG
    What operation would you like to perform?
      1) add
      2) subtract
      3) multiply
      4) divide
    MSG

  prompt(operator_prompt)

  operator = ''
  loop do
    operator = Kernel.gets().chomp()
    if %w(1 2 3 4).include?(operator)
      break
    else
      prompt(messages('valid_operator'))
    end
  end

  prompt("#{operator_to_message(operator)} the two numbers...")

  result = case operator
           when "1"
             number1.to_f() + number2.to_f()
           when "2"
             number1.to_f() - number2.to_f()
           when "3"
             number1.to_f() * number2.to_f()
           when "4"
             number1.to_f() / number2.to_f()
           end

  prompt("The result is #{result}")

  prompt(messages('another_calculation'))
  answer = nil
  loop do
    answer = Kernel.gets().chomp()
    break if answer == "yes" || answer == "no"
    prompt(messages('valid_yes_no'))
  end
  # break unless answer.downcase().start_with?('y')
  break if answer == "no"
end

prompt(messages('goodbye'))
