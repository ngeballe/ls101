require 'pry'

INITIAL_MARKER = ' '.freeze
PLAYER_MARKER = 'X'.freeze
COMPUTER_MARKER = 'O'.freeze
COMPUTER_2_MARKER = 'E'.freeze
PLAYER_2_MARKER = 'Z'.freeze
FIRST_MOVER = 'Computer'.freeze # Choose, Computer, or Player
ALL_POSSIBLE_PLAYERS = ['Player', 'Computer', 'Player 2', 'Computer 2']
PLAYER_NAMES_TO_MARKERS = { "Player" => PLAYER_MARKER,
                            "Computer" => COMPUTER_MARKER,
                            "Computer 2" => COMPUTER_2_MARKER,
                            "Player 2" => PLAYER_2_MARKER }.freeze

MARKERS_TO_PLAYERS = PLAYER_NAMES_TO_MARKERS.invert

BOARD_HEIGHT = 6 # 5
BOARD_WIDTH = 6 # 5
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

def opponent_markers(marker, players)
  markers = []
  markers = players.map { |player| PLAYER_NAMES_TO_MARKERS[player] }
  markers - [marker]
end

def next_in_array(array, current_item, wrap_around=true)
  # wrap_around means that it will go from last back around to first
  current_item_index = array.index(current_item)
  case current_item_index
  when nil
    nil
  when array.size - 1
    wrap_around ? array[0] : nil
  else
    array[current_item_index + 1]
  end
end

def next_player(players, current_player)
  next_in_array(players, current_player)
end

def next_marker(marker, players)
end

def display_square_numbers(square_nums)
  square_nums_padded = square_nums.map do |num|
    num.to_s.size == 2 ? num.to_s + " " * 3 : num.to_s + " " * 4
  end
  puts square_nums_padded.join("|")
end

def display_players_and_markers(players)
  s = "You are #{PLAYER_MARKER}. Computer is #{COMPUTER_MARKER}."
  if players.include?("Player 2")
    s.gsub!("You are", "Player 1 is")
    s << " Player 2 is #{PLAYER_2_MARKER}."
  end
  if players.include?("Computer 2") 
    s << " Computer 2 is #{COMPUTER_2_MARKER}."
  end
  puts s
end

def display_move_log(move_log)
  s = ""
  move_log.each.with_index do |turn, idx|
    marker, square = turn[:marker], turn[:square]
    s << "#{marker}: #{square}"
    s << ", " unless idx == move_log.size - 1
  end
  puts s
end

def display_board(board, players, move_log)
  system 'clear'
  display_players_and_markers(players)
  display_move_log(move_log)
  board.keys.each_slice(BOARD_WIDTH) do |square_nums|
    if SHOW_SQUARE_NUMBERS
      display_square_numbers(square_nums)
    else
      puts((" " * 5 + "|") * (BOARD_WIDTH - 1))
    end
    # display values for row
    puts board.values_at(*square_nums).map { |v| "  #{v}  " }.join("|")
    puts((" " * 5 + "|") * (BOARD_WIDTH - 1))
    unless square_nums.last == board.size
      puts((["-----"] * BOARD_WIDTH).join("+"))
    end
  end
  puts ""
end

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
  scores = {}
  ALL_POSSIBLE_PLAYERS.each { |name| scores[name] = 0 }
  scores
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

def find_left_side_neighbors(square_num, board)
  neighbors = []
  unless square_num % BOARD_WIDTH == 1
    neighbors << square_num - 1
    unless square_num <= BOARD_WIDTH
      neighbors << square_num - BOARD_WIDTH - 1
    end
    unless square_num + BOARD_WIDTH > board.size
      neighbors << square_num + BOARD_WIDTH - 1
    end
  end
  neighbors
end

def find_right_side_neighbors(square_num, board)
  neighbors = []
  unless square_num % BOARD_WIDTH == 0
    neighbors << square_num + 1
    unless square_num <= BOARD_WIDTH # if it's in first row
      neighbors << square_num - BOARD_WIDTH + 1
    end
    unless square_num + BOARD_WIDTH > board.size
      neighbors << square_num + BOARD_WIDTH + 1
    end
  end
  neighbors
end

def find_neighbors(square_num, board)
  neighbors = []
  # top
  unless square_num <= BOARD_WIDTH
    neighbors << square_num - BOARD_WIDTH
  end
  # bottom
  unless square_num + BOARD_WIDTH > board.size
    neighbors << square_num + BOARD_WIDTH
  end
  # left side
  neighbors << find_left_side_neighbors(square_num, board)
  neighbors << find_right_side_neighbors(square_num, board)
  # right side
  neighbors.flatten
end

def squares_with_neighbors(board)
  empty_squares(board).reject do |square|
    find_neighbors(square, board).all? do |neighbor|
      board[neighbor] == INITIAL_MARKER
    end
  end
end

def player_mark_square!(board, marker, move_log)
  square = ''
  player_name = MARKERS_TO_PLAYERS[marker]
  loop do
    prompt "Choose a square, #{player_name}:"
    square = gets.chomp.to_i
    break if empty_squares(board).include?(square)
    prompt "Sorry, that's not a valid choice"
  end
  board[square] = marker
  move_log << { marker: marker, square: square }
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

def fork?(board, marker)
  at_risk_squares = find_all_at_risk_squares(board, marker)
  at_risk_squares && at_risk_squares.length >= 2
end

def threat?(board, marker)
  at_risk_squares = find_all_at_risk_squares(board, marker)
  at_risk_squares && at_risk_squares.length >= 1
end

def find_fork_creator(board, marker)
  empty_squares(board).each do |square|
    board_after_move = find_board_after_move(board, marker, square)
    if fork?(board_after_move, marker)
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

def find_best_square_with_minimax(board, marker, players)
  return nil unless BOARD_WIDTH <= 3 && BOARD_HEIGHT <= 3 && players.size == 2
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

def find_winning_square(board, marker)
  WINNING_LINES.each do |line|
    square = find_at_risk_square(line, board, marker)
    return square if square
  end
  nil
end

def find_square_to_set_stage_for_fork(board, marker, players)
  find_squares_that_create_threat(board, marker).each do |threat_creator|
    board_after_move =
      find_board_after_move(board, marker, threat_creator)
    # find board after player blocks threat
    players_block = find_move_to_block_threat(board, marker)
    # square = next player's countermove
    board_after_countermove =
      find_board_after_move(board_after_move, next_marker(marker, players), players_block)
    # don't make this move if it would lead opponent to fork
    next if fork?(board_after_countermove, alternate_marker(marker))
    # make sure that player can't just win
    next if threat?(board_after_countermove, alternate_marker(marker))
    # see if board after countermove gives lets computer fork
    fork_creator = find_fork_creator(board_after_countermove, marker)
    next unless fork_creator
    square = threat_creator
    return square
  end
  nil
end

def announce_move(marker, square)
  player = MARKERS_TO_PLAYERS[marker]
  puts "#{player} marking #{square}..."
  # sleep 3
end

def num_squares_marked(board)
  board.size - board.values.count(INITIAL_MARKER)
end

def computer_mark_square!(board, marker, players, move_log)
  # choose center square at start of game
  square = (num_squares_marked(board) == 0) ? CENTER_SQUARE : nil

  # play offense--put the last one down if it's about to win
  square = find_winning_square(board, marker) unless square

  opponent_markers = opponent_markers(marker, players)
  # play defense--block if an opponent is about to win
  if !square
    # binding.pry if num_squares_marked(board) >= 10
    opponent_markers.each do |opponent_marker|
      square = find_move_to_block_threat(board, opponent_marker)
      break if square
    end
  end

  # if feasible, do minimax
  square = find_best_square_with_minimax(board, marker, players) unless square

  # try to create a fork (double threat)
  if !square && board.values.count(marker) >= NUM_TO_WIN - 2
    fork_creator = find_fork_creator(board, marker)
    square = fork_creator if fork_creator
  end

  if players.count == 2
    # see if it can set up a fork after player responds to threats
    if !square && board.values.count(marker) >= 1
      square = find_square_to_set_stage_for_fork(board, marker)
    end
  end

    # preempt double threat
    # potential_fork = find_fork_creator(board, PLAYER_MARKER)
    # block that square to preempt double threat
  unless square
    opponent_markers.each do |om|
      square = find_fork_creator(board, om)
      if square
        break
      end
    end
  end

  # choose a random square with neighbors
  square = squares_with_neighbors(board).sample unless square

  board[square] = marker

  # announce_move(marker, square)
  move_log << { marker: marker, square: square }
end

def mark_square!(board, current_player, players, move_log)
  case current_player
  when "Player"
    player_mark_square!(board, PLAYER_MARKER, move_log)
  when "Player 2"
    player_mark_square!(board, PLAYER_2_MARKER, move_log)
  when "Computer"
    computer_mark_square!(board, COMPUTER_MARKER, players, move_log)
  when "Computer 2"
    computer_mark_square!(board, COMPUTER_2_MARKER, players, move_log)
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
      return 'Computer'
    elsif board.values_at(*line).count(PLAYER_2_MARKER) == NUM_TO_WIN
      return 'Player 2'
    elsif board.values_at(*line).count(COMPUTER_2_MARKER) == NUM_TO_WIN
      return 'Computer 2'
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

scores = initialize_scores

WINNING_LINES = initialize_winning_lines

prompt "Let's play Tic Tac Toe!"

players = %w(Computer Player)

prompt('Do you want to play with a second person?')
reply = gets.chomp
if reply.downcase.start_with?('y')
  players << 'Player 2'
end

prompt('Do you want to play with a second coumputer? (y/n)')
reply = gets.chomp
if reply.downcase.start_with?('y')
  players << 'Computer 2'
end

# players.shuffle!

loop do
  board = initialize_board
  move_log = []

  # set_up_test_board_state(board, 'XO  O  X '.split(''))

  # set_up_test_board_state(board, Hash[[1,2,3,4].zip(%w(E E E E))])

  scores.keep_if { |player| players.include?(player) }

  if FIRST_MOVER == "Choose"
    prompt "Do you want to go first? (y/n)"
    answer = gets.chomp
    player_go_first = answer.downcase.start_with?('y')
    current_player = player_go_first ? "Player" : "Computer"
  else
    current_player = FIRST_MOVER
  end

  loop do
    display_board(board, players, move_log)
    mark_square!(board, current_player, players, move_log)
    current_player = next_player(players, current_player)
    break if someone_won?(board) || board_full?(board)
  end

  display_board(board, players, move_log)

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
