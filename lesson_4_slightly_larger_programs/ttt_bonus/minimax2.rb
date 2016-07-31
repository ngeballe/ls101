# thanks to http://neverstopbuilding.com/minimax

require 'pry'
# def score(board,)
# end

WINNING_LINES = [[1, 2], [2, 3], [3, 4]].freeze

def alternate_marker(marker)
  marker == 'X' ? 'O' : 'X'
end

def minimax(board, marker)
  if detect_winner(board) == 'O'
    return 1
  elsif detect_winner(board) == 'X'
    return -1
  elsif board_full?(board)
    return 0
  else
    # get a list of new game states for every possible move
    possible_moves = empty_squares(board)
    marker = alternate_marker(marker)
    new_game_states = possible_moves.map { |square| find_board_after_move(board, marker, square) }
    # create a scores list
    scores_list = []
    # For each of these states add the minimax result of that state to the scores list
    new_game_states.each do |game_state|
      scores_list << minimax(game_state, marker)
    end
    # If it's O's turn, return the maximum score from the scores list
    if marker == 'O'
      return scores_list.max
    # If it's X's turn, return the minimum score from the scores list
    elsif marker == 'X'
      return scores_list.min
    end
  end
end

def find_best_square_to_mark(board, marker)
  possible_squares = empty_squares(board)
  move_scores = {}
  possible_squares.each do |square|
    board_after_move = find_board_after_move(board, marker, square)
    move_scores[square] = minimax(board_after_move, marker)
  end
  if marker == 'O'
    move_scores.max_by { |_, v| v }[0]
  else
    move_scores.min_by { |_, v| v }[0]
  end
end

def make_move!(board, marker)
  square = find_best_square_to_mark(board, marker)
  board[square] = marker
end

# def score(board)
#   if detect_winner(board) == 'O'
#     1
#   elsif detect_winner(board) == 'X'
#     -1
#   else
#     0
#   end
# end

def detect_winner(board)
  WINNING_LINES.each do |line|
    if board.values_at(*line).count('X') == 2
      return 'X'
    elsif board.values_at(*line).count('O') == 2
      return 'O'
    end
  end
  nil
end

def board_full?(board)
  board.values.none? { |value| value == ' ' }
end

def find_board_after_move(board, marker, square)
  new_board = board.dup
  new_board[square] = marker
  new_board
end

def empty_squares(board)
  board.select { |_, v| v == ' ' }.keys
end

# from O's point of view

# goal: get 2 in a row

board = { 1 => 'X', 2 => 'O', 3 => ' ', 4 => ' ' }

# p minimax(board.merge({3=>'O'}), 'O')
# p minimax(board.merge({4=>'O'}), 'O')

p board

# p minimax(board, 'O')
# p find_best_square_to_mark(board, 'O')
make_move!(board, 'O')
p board
