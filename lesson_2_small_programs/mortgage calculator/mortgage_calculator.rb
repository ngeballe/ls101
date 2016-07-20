# mortgage_calculator.rb

require 'yaml'
MESSAGES = YAML.load_file('mortgage_calculator_messages.yml')

def prompt(message)
  puts "=> #{message}"
end

def valid_integer?(s)
  /^\d+$/.match(s)
end

def valid_decimal?(s)
  /^0?\.\d+$/.match(s)
end

def monthly_payment(loan_amount, monthly_interest, loan_duration_months)
  numerator = loan_amount * monthly_interest
  numerator *= (1 + monthly_interest)**loan_duration_months
  denominator = (1 + monthly_interest)**loan_duration_months - 1
  numerator / denominator
end

prompt(MESSAGES['welcome'])

# get loan amount
prompt(MESSAGES['loan_amount'])

loan_amount = ''

loop do
  loan_amount = gets.chomp
  break if valid_integer?(loan_amount)
  prompt(MESSAGES['valid_integer'])
end

loan_amount = loan_amount.to_i

# get APR
prompt(MESSAGES['apr'])

apr = ''
loop do
  apr = gets.chomp
  break if valid_decimal?(apr)
  prompt(MESSAGES['valid_decimal'])
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
monthly_interest = apr.to_f / 12.0
puts "The monthly interest rate is #{monthly_interest}."

# calculate loan duration in months
loan_duration_months = loan_duration_years.to_i * 12
puts "The loan duration is #{loan_duration_months} months"

# use formula
payment = monthly_payment(loan_amount, monthly_interest, loan_duration_months)
puts "The monthly payment is $#{payment}."
