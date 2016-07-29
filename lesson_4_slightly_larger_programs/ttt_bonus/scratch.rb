
INITIAL_MARKER = ' '.freeze
PLAYER_MARKER = 'X'.freeze
COMPUTER_MARKER = 'O'.freeze
MARKERS = [INITIAL_MARKER, PLAYER_MARKER, COMPUTER_MARKER]

WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                [[1, 5, 9], [3, 5, 7]]              # diagonals

def make_random_board
  new_board = {}
  (1..9).each do |num| 
    new_board[num] = MARKERS.sample
  end
  new_board
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def find_at_risk_square(line, board)
  if board.values_at(*line).count(PLAYER_MARKER) == 2
    board.select{|k,v| line.include?(k) && v == INITIAL_MARKER}.keys.first
  else
    nil
  end
end

def immediate_threat(brd, threatened_player)
  opponent_marker = (threatened_player == "Computer") ? PLAYER_MARKER : COMPUTER_MARKER
  WINNING_LINES.each do |line|
    line_squares = brd.values_at(*line)
    if line_squares.count(opponent_marker) == 2 && line_squares.count(INITIAL_MARKER) == 1
      return line # note: this will return just the first line if more than one winning_line has an immediate threat
    end
  end
  nil
end

test_results = []

10_000.times do
  board = make_random_board

  WINNING_LINES.each do |line|
    at_risk_square = find_at_risk_square(line, board)
    if at_risk_square
      test_results << at_risk_square == (immediate_threat(board, "Computer") & empty_squares(board))[0]
      break
    end
  end
  
end

p "Ran #{test_results.size} tests"
p test_results.all?