# following along with video

require 'pry'

INITIAL_MARKER = ' '
PLAYER_MARKER = 'X'
COMPUTER_MARKER = 'O'

def prompt(msg)
  puts "=> #{msg}"
end

def display_board(brd)
  system 'clear'
  puts "You are #{PLAYER_MARKER}. Computer is #{COMPUTER_MARKER}"
  puts ""
  puts "     |     |"
  puts "  #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}"
  puts "     |     |"
  puts "-----+-----+------"
  puts "     |     |"
  puts "  #{brd[4]}  |  #{brd[5]}  |  #{brd[6]}"
  puts "     |     |"
  puts "-----+-----+------"
  puts "     |     |"
  puts "  #{brd[7]}  |  #{brd[8]}  |  #{brd[9]}"
  puts "     |     |"
  puts ""
end

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER}
  new_board
  # or Hash[(1..9).zip([" "]*9)]
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def player_marks_square!(brd)
  square = ''
  loop do
    prompt "Choose a square (#{empty_squares(brd).join(', ')}):"
    square = gets.chomp.to_i
    break if empty_squares(brd).include?(square)
    prompt "Sorry, that's not a valid choice"
  end
  brd[square] = PLAYER_MARKER
end

def computer_marks_square!(brd)
  square = empty_squares(brd).sample
  brd[square] = COMPUTER_MARKER
end

def board_full?(brd)
  empty_squares(brd) == []
end

def horizontal_winner(brd)
  [PLAYER_MARKER, COMPUTER_MARKER].each do |marker|
    (0..2).each do |n|
      return marker if brd.select { |k, v| (k - 1)/ 3 == n }.values.all? { |v| v == marker }
    end
  end
  nil
end

def vertical_winner(brd)
  [PLAYER_MARKER, COMPUTER_MARKER].each do |marker|
    (0..2).each do |n|
      return marker if brd.select { |k, v| k % 3 == n }.values.all? { |v| v == marker }
    end
  end
  nil
end

def diagonal_winner(brd)
  [PLAYER_MARKER, COMPUTER_MARKER].each do |marker|
    [[1, 5, 9], [3, 5, 7]].each do |array_of_keys|
      return marker if brd.select { |k, v| array_of_keys.include?(k) }.values.all? { |v| v == marker }
    end
  end
  nil
end

def someone_won?(brd)
  !!detect_winner(brd)
end

def detect_winner(brd)
  # horizontal_winner(brd) || vertical_winner(brd) || diagonal_winner(brd)
  winning_lines = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                  [[1, 5, 9], [3, 5, 7]]              # diagonals
  winning_lines.each do |line|
    if brd[line[0]] == PLAYER_MARKER &&
      brd[line[1]] == PLAYER_MARKER &&
      brd[line[2]] == PLAYER_MARKER
      return 'Player'
    elsif brd[line[0]] == COMPUTER_MARKER &&
      brd[line[1]] == COMPUTER_MARKER &&
      brd[line[2]] == COMPUTER_MARKER
      return "Computer"
    end
  end
  nil
end

prompt "Let's play Tic Tac Toe!"

loop do
  board = initialize_board

  loop do
    display_board(board)

    player_marks_square!(board)
    break if someone_won?(board) || board_full?(board)

    computer_marks_square!(board)
    break if someone_won?(board) || board_full?(board)
  end

  display_board(board)

  if someone_won?(board)
    prompt "#{detect_winner(board)} won!"
  else
    puts "It's a tie."
  end

  prompt "Play again? (y or n)"
  answer = gets.chomp
  break unless answer.downcase.start_with?("y")
end

prompt "Good-bye! Thanks for playing."
