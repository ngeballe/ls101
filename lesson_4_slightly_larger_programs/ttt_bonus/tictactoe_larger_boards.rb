require 'pry'

INITIAL_MARKER = ' '.freeze
PLAYER_MARKER = 'X'.freeze
COMPUTER_MARKER = 'O'.freeze
FIRST_MOVER = "Computer".freeze # Choose, Computer, or Player
PLAYER_NAMES_TO_MARKERS = { "Player" => PLAYER_MARKER,
                            "Computer" => COMPUTER_MARKER }.freeze
MARKERS_TO_PLAYERS = { PLAYER_MARKER => "Player",
                       COMPUTER_MARKER => "Computer" }.freeze

BOARD_HEIGHT = 5 # 5
BOARD_WIDTH = 10 # 5
NUM_TO_WIN = 4 # number in a row required to win # 3
SHOW_SQUARE_NUMBERS = true

CENTER_SQUARE = ''.freeze
CENTER_ROW = BOARD_HEIGHT / 2 + 1
CENTER_COLUMN = BOARD_WIDTH / 2 + 1
CENTER_SQUARE = (CENTER_ROW - 1) * BOARD_WIDTH + CENTER_COLUMN

def prompt(msg)
  puts "=> #{msg}"
end

def joinor(arr, delimiter=', ', word='or')
  arr[-1] = "#{word} #{arr.last}" if arr.size > 1
  arr.size == 2 ? arr.join(' ') : arr.join(delimiter)
end

def alternate_marker(marker)
  marker == PLAYER_MARKER ? COMPUTER_MARKER : PLAYER_MARKER
end

def alternate_player(player)
  player == "Player" ? "Computer" : "Player"
end

# rubocop:disable Metrics/AbcSize
def display_board(board)
  system 'clear'
  puts "You are #{PLAYER_MARKER}. Computer is #{COMPUTER_MARKER}"
  puts ""
  board.keys.each_slice(BOARD_WIDTH) do |square_nums|
    if SHOW_SQUARE_NUMBERS
      square_nums_padded = square_nums.map do |num|
        num.to_s.size == 2 ? num.to_s + " " * 3 : num.to_s + " " * 4
      end
      puts square_nums_padded.join("|")
    else
      puts (" " * 5 + "|") * (BOARD_WIDTH - 1)
    end
    values_for_row = board.values_at(*square_nums)
    puts values_for_row.map { |v| "  #{v}  " }.join("|")
    puts (" " * 5 + "|") * (BOARD_WIDTH - 1)
    puts (["-----"] * BOARD_WIDTH).join("+") unless square_nums.last == board.size
  end
  puts ""
end
# rubocop:enable Metrics/AbcSize

def initialize_board
  new_board = {}
  num_squares = BOARD_HEIGHT * BOARD_WIDTH
  (1..num_squares).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def set_up_test_board_state(board, squares_marked)
  if squares_marked.class == Hash
    board.merge!(squares_marked)
  elsif squares_marked.class == Array
    board.merge!(Hash[(1..9).zip(squares_marked)])
  end
end

def initialize_scores
  { "Player" => 0, "Computer" => 0 }
end

def display_scores(scores)
  puts "The score is:"
  scores.each do |competitor, score|
    puts "#{competitor} -- #{score}"
  end
end

def empty_squares(board)
  board.keys.select { |num| board[num] == INITIAL_MARKER }
end

def find_neighbors(square_num, board)
  neighbors = []
  # top
  neighbors << square_num - BOARD_WIDTH unless square_num <= BOARD_WIDTH
  # bottom
  neighbors << square_num + BOARD_WIDTH unless square_num + BOARD_WIDTH > board.size
  # left side
  unless square_num % BOARD_WIDTH == 1
    neighbors << square_num - 1
    neighbors << square_num - BOARD_WIDTH - 1 unless square_num <= BOARD_WIDTH
    neighbors << square_num + BOARD_WIDTH - 1 unless square_num + BOARD_WIDTH > board.size
  end
  # right side
  unless square_num % BOARD_WIDTH == 0
    neighbors << square_num + 1
    neighbors << square_num - BOARD_WIDTH + 1 unless square_num <= BOARD_WIDTH
    neighbors << square_num + BOARD_WIDTH + 1 unless square_num + BOARD_WIDTH > board.size
  end
  neighbors
end

def squares_with_neighbors(board)
  empty_squares(board).reject do |square|
    find_neighbors(square, board).all? { |neighbor| board[neighbor] == INITIAL_MARKER }
  end
end

def player_mark_square!(board)
  square = ''
  loop do
    # prompt "Choose a square (#{joinor(empty_squares(board))}):"
    prompt "Choose a square:"
    square = gets.chomp.to_i
    break if empty_squares(board).include?(square)
    prompt "Sorry, that's not a valid choice"
  end
  board[square] = PLAYER_MARKER
end

def find_board_after_move(board, marker, square)
  # predicts what board will look like after move
  board.merge(square => marker)
end

def find_at_risk_square(line, board, marker)
  if board.values_at(*line).count(marker) == NUM_TO_WIN - 1
    board.select { |k, v| line.include?(k) && v == INITIAL_MARKER }.keys.first
  end
end

def find_all_at_risk_squares(board, marker)
  squares = []
  WINNING_LINES.each do |line|
    square = find_at_risk_square(line, board, marker)
    squares << square if square
  end
  if squares.empty?
    nil
  else
    squares
  end
end

def double_threat?(board, marker)
  at_risk_squares = find_all_at_risk_squares(board, marker)
  at_risk_squares && at_risk_squares.length >= 2
end

def threat?(board, marker)
  at_risk_squares = find_all_at_risk_squares(board, marker)
  at_risk_squares && at_risk_squares.length >= 1
end

def find_a_square_that_creates_double_threat(board, marker)
  empty_squares(board).each do |square|
    board_after_move = find_board_after_move(board, marker, square)
    if double_threat?(board_after_move, marker)
      return square
    end
  end
  nil
end

def find_squares_that_create_threat(board, marker)
  threat_creators = []
  empty_squares(board).each do |square|
    board_after_move = find_board_after_move(board, marker, square)
    if threat?(board_after_move, marker)
      threat_creators << square
    end
  end
  threat_creators
end

def find_move_to_block_threat(board, marker_for_threatening_player)
  WINNING_LINES.each do |line|
    square = find_at_risk_square(line, board, marker_for_threatening_player)
    return square if square
  end
  nil
end

def minimax(board, marker)
  return 1 if detect_winner(board) == "Computer"
  return -1 if detect_winner(board) == "Player"
  return 0 if board_full?(board)
  marker = alternate_marker(marker)
  possible_moves = empty_squares(board)
  new_game_states = possible_moves.map do |square|
    find_board_after_move(board, marker, square)
  end
  scores_list = []
  new_game_states.each do |game_state|
    scores_list << minimax(game_state, marker)
  end
  (marker == COMPUTER_MARKER) ? scores_list.max : scores_list.min
end

def find_best_square_with_minimax(board, marker)
  squares_to_search = empty_squares(board)
  move_scores = {}
  squares_to_search.each do |square|
    board_after_move = find_board_after_move(board, marker, square)
    move_scores[square] = minimax(board_after_move, marker)
  end
  if marker == 'O'
    move_scores.max_by { |_, v| v }[0]
  else
    move_scores.min_by { |_, v| v }[0]
  end
end

def computer_mark_square!(board)
  square = nil

  # center_square = board.size / 2 + 1

  square = CENTER_SQUARE if board.values.count(INITIAL_MARKER) == board.values.size # first turn

  if !square
    # play offense--put the last one down if it's about to win
    WINNING_LINES.each do |line|
      square = find_at_risk_square(line, board, COMPUTER_MARKER)
      break if square
    end
  end

  if !square
    # play defense--block if the player has two in a row
    # WINNING_LINES.each do |line|
    #   square = find_at_risk_square(line, board, PLAYER_MARKER)
    #   break if square
    # end
    square = find_move_to_block_threat(board, PLAYER_MARKER)
  end

  # if feasible, do minimax
  if !square && BOARD_WIDTH <= 3 && BOARD_HEIGHT <= 3
    square = find_best_square_with_minimax(board, COMPUTER_MARKER) if !square
  end

  # try to create double threats (situation where computer makes two immediate threats so the player can't block both)
  if !square && board.values.count(COMPUTER_MARKER) >= NUM_TO_WIN - 2
    double_threat_creator = find_a_square_that_creates_double_threat(board, COMPUTER_MARKER)
    square = double_threat_creator if double_threat_creator
  end

  # see if it can find a move that will lead do a double threat when players respond to threats
  if !square && board.values.count(COMPUTER_MARKER) >= 1
    threat_creators = find_squares_that_create_threat(board, COMPUTER_MARKER)
    threat_creators.each do |threat_creator|
      # THIS WILL ONLY CHECK OUT FIRST SQUARE THAT CREATES THREAT
      board_after_move = find_board_after_move(board, COMPUTER_MARKER, threat_creator)
      # find board after player blocks threat
      players_defensive_square = nil
      WINNING_LINES.each do |line|
        players_defensive_square = find_at_risk_square(line, board_after_move, COMPUTER_MARKER)
        break if players_defensive_square
      end
      # square = player's countermove
      board_after_countermove = find_board_after_move(board_after_move, PLAYER_MARKER, players_defensive_square)
      # if the player would now be making a double threat, the computer shouldn't make this move
      if double_threat?(board_after_countermove, PLAYER_MARKER)
        next
      end
      # see if board after countermove gives computer the chance to make a double threat
      # but make sure that the computer CAN make a double threat in that scenario, that it wouldn't need to just let the computer win
      double_threat_creator = find_a_square_that_creates_double_threat(board_after_countermove, COMPUTER_MARKER)
      is_there_threat_there = threat?(board_after_countermove, PLAYER_MARKER)
      if double_threat_creator && !threat?(board_after_countermove, PLAYER_MARKER)
        square = threat_creator # use the threat creator as square if it sets up a double threat
        break if square
      end
    end
  end

  squares_with_neighbors = squares_with_neighbors(board)

  # preempt double threat
  if !square
    potential_double_threat = find_a_square_that_creates_double_threat(board, PLAYER_MARKER)
    square = potential_double_threat if potential_double_threat # block that square to preempt double threat
    # binding.pry
    # empty_squares(board).each do |opponents_potential_move|
    #   board_after_move = find_board_after_move(board, PLAYER_MARKER, opponents_potential_move)
    #   opponents_double_threat_creator = find_a_square_that_creates_double_threat(board_after_move, PLAYER_MARKER)
    # end
  end

  # choose a random square with neighbors
  if !square
    square = squares_with_neighbors.sample
  end

  # use minimax with squares adjacent to markers to cut down on search time
  # if !square
  #   squares_with_neighbors = find_neighbors()
  #   square = find_best_square_with_minimax(board, COMPUTER_MARKER)
  # end

  # random
  if !square
    square = empty_squares(board).sample
  end

  # use minimax
  if !square
    square = find_best_square_with_minimax(board, COMPUTER_MARKER) # if !square
  end

  board[square] = COMPUTER_MARKER
end

def mark_square!(board, current_player)
  case current_player
  when "Player"
    player_mark_square!(board)
  when "Computer"
    computer_mark_square!(board)
  end
end

def board_full?(board)
  empty_squares(board) == []
end

def someone_won?(board)
  !!detect_winner(board)
end

def detect_winner(board)
  WINNING_LINES.each do |line|
    if board.values_at(*line).count(PLAYER_MARKER) == NUM_TO_WIN
      return 'Player'
    elsif board.values_at(*line).count(COMPUTER_MARKER) == NUM_TO_WIN
      return "Computer"
    end
  end
  nil
end

def update_scores!(scores, winner)
  scores[winner] += 1
end

def someone_won_game?(scores)
  !!detect_game_winner(scores)
end

def detect_game_winner(scores)
  scores.keys.detect { |competitor| scores[competitor] == 5 }
end

def add_horizontal_winning_lines!(winning_lines, squares)
  squares.each_slice(BOARD_WIDTH) do |row_of_squares|
    row_of_squares.each_cons(NUM_TO_WIN).each do |horizontal_line|
      winning_lines << horizontal_line
    end
  end
end

def add_vertical_winning_lines!(winning_lines, squares)
  columns = (1..BOARD_WIDTH).map do |column_num|
    column_num.step(squares.size, BOARD_WIDTH).to_a
  end
  columns.each do |column|
    column.each_cons(NUM_TO_WIN).each do |vertical_line|
      winning_lines << vertical_line
    end
  end
end

def find_diagonal(start, top_left_to_bottom_right)
  if top_left_to_bottom_right
    (0..NUM_TO_WIN - 1).map do |n|
      start + (BOARD_WIDTH + 1) * n
    end
  else
    (0..NUM_TO_WIN - 1).map do |n|
      start + (BOARD_WIDTH - 1) * n
    end
  end
end

def add_diagonal_winning_lines!(winning_lines, squares)
  squares.each_slice(BOARD_WIDTH).with_index do |row_of_squares, row_idx|
    if row_idx <= BOARD_HEIGHT - NUM_TO_WIN
      row_of_squares[0..-NUM_TO_WIN].each do |diag_start| # \ diags
        winning_lines << find_diagonal(diag_start, true)
      end
      row_of_squares[NUM_TO_WIN - 1..-1].each do |diag_start| # / diags
        winning_lines << find_diagonal(diag_start, false)
      end
    end
  end
end

def initialize_winning_lines
  squares = (1..BOARD_WIDTH * BOARD_HEIGHT).to_a
  winning_lines = []

  add_horizontal_winning_lines!(winning_lines, squares)
  add_vertical_winning_lines!(winning_lines, squares)
  add_diagonal_winning_lines!(winning_lines, squares)

  winning_lines
end

WINNING_LINES = initialize_winning_lines

prompt "Let's play Tic Tac Toe!"
scores = initialize_scores

loop do
  board = initialize_board

  # set_up_test_board_state(board, 'XO  O  X '.split(''))

  if FIRST_MOVER == "Choose"
    prompt "Do you want to go first? (y/n)"
    answer = gets.chomp
    player_go_first = answer.downcase.start_with?('y')
    current_player = player_go_first ? "Player" : "Computer"
  else
    current_player = FIRST_MOVER
  end

  loop do
    display_board(board)
    mark_square!(board, current_player)
    current_player = alternate_player(current_player)
    break if someone_won?(board) || board_full?(board)
  end

  display_board(board)

  if someone_won?(board)
    winner = detect_winner(board)
    prompt "#{winner} won!"
    update_scores!(scores, winner)
  else
    puts "It's a tie."
  end

  display_scores(scores)

  if someone_won_game?(scores)
    prompt "#{detect_game_winner(scores)} won the game!"
    break
  end

  prompt "Play again? (y or n)"
  answer = gets.chomp
  break unless answer.downcase.start_with?("y")
end

prompt "Good-bye! Thanks for playing."
