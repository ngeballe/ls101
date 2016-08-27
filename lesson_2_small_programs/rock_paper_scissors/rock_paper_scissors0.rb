require "pry"

MOVE_OPTIONS = %w(rock paper scissors)
FIRST_LETTERS_TO_OPTIONS = { "r" => "rock", "p" => "paper", "s" => "scissors" }
first_letters = FIRST_LETTERS_TO_OPTIONS.keys

def find_winner(user_move, computer_move)
  case user_move
  when computer_move
    nil
  when "rock"
    computer_move == "paper" ? :computer : :user
  when "paper"
    computer_move == "scissors" ? :computer : :user
  when "scissors"
    computer_move == "rock" ? :computer : :user
  end
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
  puts "Type r for rock, p for paper, or s for scissors"

  user_move_letter = ''
  loop do
    user_move_letter = gets.chomp
    break if first_letters.include?(user_move_letter)
    puts "That's not a valid choice. Type r for rock, \
p for paper, or s for scissors."
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
  puts "You chose #{user_move}. The computer chose #{computer_move}. \
#{winner_message}"
  report(scores)

  # ask to play again
  puts "Do you want to play again? Type 'y' to play another round."
  reply = gets.chomp.downcase

  break unless reply == "y"
end
