# n = ''

# loop do
#   n = rand(0..100)
#   p n
#   break if n > 50
# end

# p n

# board = [["O", "b1", "c1"], ["O", "b2", "c2"], ["O", "O", "X"]]

# (0..2).each do |col_index|
#   if board.all? { |row| row[col_index] == "X" }
#     p "X is the winner"
#   elsif board.all? { |row| row[col_index] == "O" }
#     p "O is the winner"
#   end
# end

# def diagonal_winner(board, x_player, o_player)
#   diagonal1 = [board[0][0], board[1][1], board[2][2]]
#   diagonal2 = [board[2][0], board[1][1], board[0][2]]
#   [diagonal1, diagonal2].each do |diagonal_array|
#     if diagonal_array.uniq!.length == 1 # if all same letter
#       if diagonal_array[0] == "X"
#         return x_player
#       else
#         return o_player
#       end
#     end
#   end
#   nil
# end

# board = [["O", " ", "O"], [" ", "O", "O"], ["O", "O", "X"]]
# p diagonal_winner(board, :bob, :sue)


# alternating loop

your_score = 0
computer_score = 0

def winner?(your_score, computer_score)
  if your_score >= 10
    "you"
  elsif computer_score >= 10
    "the computer"
  else
    nil
  end
end



loop do
  your_score += rand(2..4)
  puts "You have #{your_score} points"
  break if winner?(your_score, computer_score)
  computer_score += rand(2..4)
  puts "The computer has #{computer_score} points"
  break if winner?(your_score, computer_score)
  puts "Continue?"
  reply = gets.chomp
end

puts "The winner is: #{winner?(your_score, computer_score)}"