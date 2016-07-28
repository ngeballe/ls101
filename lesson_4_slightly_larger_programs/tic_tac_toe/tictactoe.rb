require 'pry'
require 'yaml'
MESSAGES = YAML.load_file('tictactoe_messages.yml')

COLUMN_LETTERS_TO_NUMBERS = {"a" => 0, "b" => 1, "c" => 2}

def display(board)
  puts " " + %w(a b c).join("|")
  board.each_with_index do |row, row_idx|
    print row_idx + 1
    row.each_with_index do |column, col_idx|
      print column
      print "|" unless col_idx == row.length - 1
    end
    print "\n"
    puts "-"*6 unless row_idx == board.length - 1
  end
end

def prompt(message)
  puts "=> #{message}"
end

def valid_choice?(user_choice)
  # must be 2 characters [a, b, c], then [1, 2, 3]
  return false unless /^[abc][123]$/i.match(user_choice)
  true
end

def row_and_column(user_choice)
  row_num = user_choice[1].to_i - 1 # to make it 0-based
  col_num = COLUMN_LETTERS_TO_NUMBERS[user_choice[0].downcase]
  [row_num, col_num]
end

def mark_square(board, row_num, col_num, letter)
  board[row_num][col_num] = letter
end

def computer_mark_square(board, letter)
  return if full?(board)
  row_num = ''
  col_num = ''
  loop do
    row_num = rand(0..2)
    col_num = rand(0..2)
    break unless square_occupied?(board, row_num, col_num)
  end
  mark_square(board, row_num, col_num, letter)
end

def square_occupied?(board, row_num, col_num)
  board[row_num][col_num] != " "
end

# def three_horizontally(letter)
  
# end

def diagonal_winner(board, x_player, o_player)
  diagonal1 = [board[0][0], board[1][1], board[2][2]]
  diagonal2 = [board[2][0], board[1][1], board[0][2]]
  [diagonal1, diagonal2].each do |diagonal_array|
    if diagonal_array == ["X"] * 3
      return x_player
    elsif diagonal_array == ["O"] * 3
      return o_player
    end
  end
  nil
end

def winner(board, x_player, o_player)
  # 3 horizontal?
  board.each do |row|
    return x_player if row.all? { |value| value == "X" }
    return o_player if row.all? { |value| value == "O" }
  end
  # 3 vertical?
  (0..2).each do |col_index|
    if board.all? { |row| row[col_index] == "X" }
      return x_player
    elsif board.all? { |row| row[col_index] == "O" }
      return o_player
    end
  end
  # 3 diagonal?
  diagonal_winner = diagonal_winner(board, x_player, o_player)
  return diagonal_winner if diagonal_winner
  nil
end

# def winner_or_tie?(board)
#   # is there a winner?
#   # is a tie
#   if 
# end

def display_winner(winner)
  case winner
  when :user
    puts "You won. Congrats!"
  when :computer
    puts "The computer won."
  end
end

def full?(board)
  board.flatten.all? { |value| value != " " }
end

#p full?([["X", "X", "O"], ["X", "X", "X"], ["X", "O", "O"]]) # => true


prompt(MESSAGES["welcome"])

loop do
  board = [[" ", " ", " "],
          [" ", " ", " "],
          [" ", " ", " "]]
  loop do
    # 1. Display the inital empty 3x3 board
    display(board)
    winner = winner(board, :user, :computer)
    if winner
      display_winner(winner)
      break
    elsif full?(board)
      puts "It's a tie"
      break
    end

    # 2. Ask the user to mark a square
    user_choice = ''
    loop do
      prompt(MESSAGES["take_turn"])
      user_choice = gets.chomp
      if valid_choice?(user_choice)
        row_chosen, col_chosen = row_and_column(user_choice)
        if square_occupied?(board, row_chosen, col_chosen)
          prompt(MESSAGES["square_occupied"])
        else
          break
        end
      else
        prompt(MESSAGES["invalid_choice"])
      end
    end
    row_chosen, col_chosen = row_and_column(user_choice)
    mark_square(board, row_chosen, col_chosen, "X")

    puts "Your move was:"
    display(board)

    # break if winner(board, :user, :computer)
    winner = winner(board, :user, :computer)
    if winner 
      display_winner(winner)
      break
    elsif full?(board)
      puts "It's a tie"
      break
    end
    # 3. Computer marks a square
    computer_mark_square(board, "O")
    puts "The computer's move was:"
  end
  prompt("Do you want to play again?")
  answer = gets.chomp
  break unless answer.downcase.start_with?("y")
end

prompt(MESSAGES["goodbbye"])
# 5. If winner, display winner.
# 6. If board is full, display tie.
# 7. If neither winner nor full board, go to #2.
# 8. Play again?
# 9. If yes, go to #1
# 10. Goodbye!