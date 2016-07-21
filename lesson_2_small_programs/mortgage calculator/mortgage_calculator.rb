# mortgage_calculator.rb

require 'pry'
require 'yaml'
MESSAGES = YAML.load_file('mortgage_calculator_messages.yml')

def prompt(message)
  puts "=> #{message}"
end

def valid_integer?(s)
  /^\d+$/.match(s)
end

def valid_number?(s)
  /\d/.match(s) && /^\d*\.?\d*$/.match(s)
end

def monthly_payment(loan_amount, monthly_interest_rate, loan_duration_months)
  loan_amount * monthly_interest_rate /
    (1 - (1 + monthly_interest_rate)**-loan_duration_months)
end

# tests
# puts monthly_payment(100000, 0.0041666667, 360)
# puts monthly_payment(30000, 0.06/12, 10*12)
# puts monthly_payment(93246, 0.042/12, 13*12)
# /tests

prompt(MESSAGES['welcome'])

loop do
  # get loan amount
  prompt(MESSAGES['loan_amount'])

  loan_amount = ''
  loop do
    loan_amount = gets.chomp
    break if valid_number?(loan_amount)
    prompt(MESSAGES['valid_number'])
  end

  loan_amount = loan_amount.to_f

  # get APR
  prompt(MESSAGES['apr'])

  apr = ''
  loop do
    apr = gets.chomp
    break if valid_number?(apr)
    prompt(MESSAGES['valid_number'])
  end

  # get loan duration
  prompt(MESSAGES['loan_duration'])

  loan_duration_years = ''
  loop do
    loan_duration_years = gets.chomp
    break if valid_integer?(loan_duration_years)
    prompt(MESSAGES['valid_integer'])
  end

  # calculate monthly interest rate
  annual_interest = apr.to_f / 100
  monthly_interest_rate = annual_interest / 12

  # calculate loan duration in months
  loan_duration_months = loan_duration_years.to_i * 12

  # use formula
  payment = monthly_payment(loan_amount, monthly_interest_rate,
                            loan_duration_months)
  puts "The monthly payment is $#{format('%02.2f', payment)}."

  prompt(MESSAGES['another_calculation'])
  reply = gets.chomp
  break unless reply.downcase.start_with?('y')
end

prompt(MESSAGES['goodbye'])
