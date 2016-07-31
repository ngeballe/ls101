# def score(board,)
  
# end

def minimax(board, marker)
  possible_moves = empty_squares(board)
  possible_moves.each do |square|
    p square
    board_afte_move = find_board_after_move(board, marker, square)
    p board_afte_move
    if score(board_afte_move) == 1
      move_score = 1
      p move_score
      puts
    elsif score(board_afte_move) == -1
      move_score = -1
      p move_score
      puts
    elsif score(board_afte_move) == 0
      if board_full?(board)
        move_score = 0
        p move_score
      else
        # return minimax
      end
    end
  end
  # choose move with maximum score
end

def score(board)
  if detect_winner(board) == 'O'
    1
  elsif detect_winner(board) == 'X'
    -1
  else
    0
  end
end

def detect_winner(board)
  if board[1] == 'X' && board[2] == 'X' ||
     board[2] == 'X' && board[3] == 'X' ||
     board[3] == 'X' && board[4] == 'X'
    return 'X'
  elsif board[1] == 'O' && board[2] == 'O' ||
     board[2] == 'O' && board[3] == 'O' ||
     board[3] == 'O' && board[4] == 'O'
    return 'O'
  end
  nil
end

def board_full?(board)
  board.values.none? { |value| value == ' '}
end

def find_board_after_move(board, marker, square)
  new_board = board.dup
  new_board[square] = marker
  new_board
end

def empty_squares(board)
  board.select { |k, v| v == ' ' }.keys
end

# from O's point of view

# goal: get 2 in a row

board = {1=>'X', 2=>'O', 3=>' ', 4=>' '}

minimax(board, 'O')

# def factorial(n)
#   return 0 if n < 0
#   return 1 if n < 2
#   n * factorial(n - 1)
# end

# p factorial(5)