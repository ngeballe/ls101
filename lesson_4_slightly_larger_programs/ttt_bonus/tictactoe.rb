# following along with video

require 'pry'

WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                [[1, 5, 9], [3, 5, 7]]              # diagonals

INITIAL_MARKER = ' '.freeze
PLAYER_MARKER = 'X'.freeze
COMPUTER_MARKER = 'O'.freeze
# FIRST_MOVER = "choose".freeze
FIRST_MOVER = "Computer"
PLAYER_NAMES_TO_MARKERS = { "Player" => PLAYER_MARKER, "Computer" => COMPUTER_MARKER }
MARKERS_TO_PLAYERS = { PLAYER_MARKER => "Player", COMPUTER_MARKER => "Computer" }

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

# rubocop:disable Metrics/AbcSize
def display_board(board)
  system 'clear'
  puts "You are #{PLAYER_MARKER}. Computer is #{COMPUTER_MARKER}"
  puts ""
  puts "     |     |"
  puts "  #{board[1]}  |  #{board[2]}  |  #{board[3]}"
  puts "     |     |"
  puts "-----+-----+------"
  puts "     |     |"
  puts "  #{board[4]}  |  #{board[5]}  |  #{board[6]}"
  puts "     |     |"
  puts "-----+-----+------"
  puts "     |     |"
  puts "  #{board[7]}  |  #{board[8]}  |  #{board[9]}"
  puts "     |     |"
  puts ""
end
# rubocop:enable Metrics/AbcSize

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def set_up_test_board_state(board, squares_marked)
  board.merge!(squares_marked)
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

def player_mark_square!(board)
  square = ''
  loop do
    prompt "Choose a square (#{joinor(empty_squares(board))}):"
    square = gets.chomp.to_i
    break if empty_squares(board).include?(square)
    prompt "Sorry, that's not a valid choice"
  end
  board[square] = PLAYER_MARKER
end

def find_at_risk_square(line, board, marker)
  if board.values_at(*line).count(marker) == 2
    board.select{|k,v| line.include?(k) && v == INITIAL_MARKER}.keys.first
  else
    nil
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

# def find_a_square_that_creates_threat(board, marker)
#   empty_squares(board).each do |square|
#     board_after_move = find_board_after_move(board, marker, square)
#     if threat?(board_after_move, COMPUTER_MARKER)
#       return square
#     end
#   end
#   nil 
# end

def find_squares_that_create_threat(board, marker)
  threat_creators = []
  empty_squares(board).each do |square|
    board_after_move = find_board_after_move(board, marker, square)
    if threat?(board_after_move, COMPUTER_MARKER)
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

def find_board_after_move(board, marker, square)
  # predicts what board will look like after move
  board.merge({ square => marker })
end

def minimax(board, marker)
  # marker is for player whose turn it is
  player_name = MARKERS_TO_PLAYERS[marker]
  # If the game is over, return the score from X's perspective.
  if detect_winner(board) == "Computer"
    return 1
  elsif detect_winner(board) == "Player"
    return -1
  elsif board_full?(board)
    return 0
  else
    # get a list of new game states for every possible move
    marker = alternate_marker(marker)
    possible_moves = empty_squares(board)
    new_game_states = possible_moves.map { |square| find_board_after_move(board, marker, square) }
    # create a scores list
    scores_list = []
    # For each of these states add the minimax result of that state to the scores list
    new_game_states.each do |game_state|
      scores_list << minimax(game_state, marker)
    end
    # If it's computer's turn, return the maximum score from the scores list
    if marker == COMPUTER_MARKER
      return scores_list.max
    # If it's player's turn, return the minimum score from the scores list
    elsif marker == PLAYER_MARKER
      return scores_list.min
    end
  end
  # Otherwise get a list of new game states for every possible move
  # Create a scores list
  # For each of these states add the minimax result of that state to the scores list
  # If it's X's turn, return the maximum score from the scores list
  # If it's O's turn, return the minimum score from the scores list
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

def computer_mark_square!(board)
  square = nil

  square = 5 if board.values.count(INITIAL_MARKER) == board.values.size
  
  # use minimax
  square = find_best_square_to_mark(board, COMPUTER_MARKER) if !square

  if !square
    # play offense--put the 3rd one down if it's about to win
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

  # try to create double threats (situation where computer makes two immediate threats so the player can't block both)
  if !square && board.values.count(COMPUTER_MARKER) >= 2 # if computer has  2 or more pieces on the board--if not, there couldn't be a way to create a double-threat
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
      # see if board after countermove gives computer the chance to make a double threat
      # but make sure that the computer CAN make a double threat in that scenario, that it wouldn't need to just let the computer win
      double_threat_creator = find_a_square_that_creates_double_threat(board_after_countermove, COMPUTER_MARKER)
      is_there_threat_there = threat?(board_after_countermove, PLAYER_MARKER)
      # binding.pry if board.values.count >= 2
      if double_threat_creator && !threat?(board_after_countermove, PLAYER_MARKER)
        square = threat_creator # use the threat creator as square if it sets up a double threat
      end
    end
  end

  if !square
    # binding.pry if board.values.count(COMPUTER_MARKER) >= 2
    square = empty_squares(board).sample
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
    if board.values_at(*line).count(PLAYER_MARKER) == 3
      return 'Player'
    elsif board.values_at(*line).count(COMPUTER_MARKER) == 3
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

def alternate_player(player)
  player == "Player" ? "Computer" : "Player"
end

prompt "Let's play Tic Tac Toe!"
player_victories = 0
computer_victories = 0
scores = initialize_scores

loop do
  board = initialize_board

  # o_wins = { 1=>'X', 2=>'X', 3=>'O', 4=>' ', 5=>'O', 6=>'X', 7=>'O', 8=>' ', 9=>'O' }
  # x_wins = { 1=>'X', 2=>'X', 3=>'X', 4=>' ', 5=>'O', 6=>'X', 7=>'O', 8=>' ', 9=>'O' }
  # o_about_to_win = { 1=>'X', 2=>'X', 3=>'O', 4=>' ', 5=>'O', 6=>'X', 7=>' ', 8=>' ', 9=>'O' }
  # x_about_to_win = { 1 => 'O', 2 => 'O', 3 => 'X', 4 => ' ', 5 => 'X', 6 => ' ',  7 => ' ', 8 => ' ', 9 => ' ' }
  # set_up_test_board_state(board, x_about_to_win)

  if FIRST_MOVER == "choose"
    prompt "Do you want to go first? (y/n)"
    answer = gets.chomp
    if answer.downcase.start_with?('y')
      current_player = "Player"
    else
      current_player = "Computer"
    end
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
