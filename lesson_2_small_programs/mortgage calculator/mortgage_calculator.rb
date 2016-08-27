# mortgage_calculator.rb

require 'pry'
require 'yaml'
MESSAGES = YAML.load_file('mortgage_calculator_messages.yml')

def prompt(message)
  puts "=> #{message}"
end

def valid_number?(s)
  /\d/.match(s) && /^\d*\.?\d*$/.match(s)
end

def monthly_payment(loan_amount, monthly_interest_rate, loan_duration_months)
  loan_amount * monthly_interest_rate /
    (1 - (1 + monthly_interest_rate)**-loan_duration_months)
end

def validate_input_number
  loop do
    input = gets.chomp
    break input if valid_number?(input)
    prompt MESSAGES['valid_number']
  end
end

def validate_input_options(options)
  loop do
    input = gets.chomp
    break input if options.include?(input)
    prompt "That's not a valid choice. Please enter #{join_or(options)}."
  end
end

def join_or(array, joiner = "or")
  case array.size
  when 1
    array[0]
  when 2
    array.join(" #{joiner} ")
  else
    array[0..-2].join(", ") + ", #{joiner} #{array[-1]}"
  end
end

system 'clear'
prompt(MESSAGES['welcome'])

loop do
  # get loan amount
  prompt(MESSAGES['loan_amount'])
  loan_amount = validate_input_number.to_f

  # get APR
  prompt(MESSAGES['apr'])
  monthly_interest_rate = validate_input_number.to_f / 100 / 12

  # get loan duration
  prompt(MESSAGES['loan_duration'])
  loan_duration_years = validate_input_number.to_f
  loan_duration_months = loan_duration_years * 12

  # use formula
  payment = monthly_payment(loan_amount, monthly_interest_rate,
                            loan_duration_months)
  puts "The monthly payment is $#{format('%02.2f', payment)}."

  prompt(MESSAGES['another_calculation'])
  reply = validate_input_options(%w(yes no))
  break if reply == "no"

  system 'clear'
end

prompt(MESSAGES['goodbye'])
