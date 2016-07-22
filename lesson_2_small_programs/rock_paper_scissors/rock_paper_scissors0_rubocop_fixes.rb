require "pry"

MOVE_OPTIONS = %w(rock paper scissors)
FIRST_LETTERS_TO_OPTIONS = { "r" => "rock", "p" => "paper", "s" => "scissors" }
first_letters = FIRST_LETTERS_TO_OPTIONS.keys

def winning_move?(potential_winning_move, opponent_move)
  # returns true iff potential_winning_move beats countermove
  if potential_winning_move == "rock"
    opponent_move == "scissors"
  elsif potential_winning_move == "scissors"
    opponent_move == "paper"
  elsif potential_winning_move == "paper"
    opponent_move == "rock"
  end
end

def find_winner(user_move, computer_move)
  return nil if user_move == computer_move # tie
  winning_move?(user_move, computer_move) ? :user : :computer
end

def report(scores)
  puts "The score is:"
  puts "  You: #{scores[:user]}"
  puts "  Computer: #{scores[:computer]}"
end

puts "Welcome to Rock, Paper, Scissors!"

scores = { computer: 0, user: 0 }

loop do
  # user chooses rock, paper, or scissors
  options_message = "Type r for rock, p for paper, or s for scissors"
  puts options_message

  user_move_letter = ''
  loop do
    user_move_letter = gets.chomp
    break if first_letters.include?(user_move_letter)
    puts "That's not a valid choice. Try again. #{options_message}"
  end

  user_move = FIRST_LETTERS_TO_OPTIONS[user_move_letter]
  puts user_move
  computer_move = MOVE_OPTIONS.sample
  # computer chooses rock, paper, or scissors

  # report results

  winner = find_winner(user_move, computer_move)
  winner_message = case winner
                   when :user
                     "Victory is yours! I salute you."
                   when :computer
                     "Sorry, you lost. Better luck next time, old chap!"
                   when nil
                     "It's a tie."
                   end

  scores[winner] += 1 if winner

  # report victory
  print "You chose #{user_move}. The computer chose #{computer_move}. "
  print winner_message, "\n"
  report(scores)

  # ask to play again
  puts "Do you want to play again? Type 'y' to play another round."
  reply = gets.chomp.downcase

  break unless reply == "y"
end
