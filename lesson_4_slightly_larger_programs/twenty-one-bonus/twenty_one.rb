require 'pry'

SUITS = ['H', 'D', 'S', 'C'].freeze
VALUES = ['2', '3', '4', '5', '6', '7', '8', '9',
          '10', 'J', 'Q', 'K', 'A'].freeze

def prompt(msg)
  puts "=> #{msg}"
end

def initialize_deck
  SUITS.product(VALUES).shuffle
end

def full_name(card)
  card[]
end

def total(cards)
  values = cards.map { |card| card[1] }

  sum = 0
  values.each do |value|
    sum += if value == "A"
             11
           elsif value.to_i == 0 # J, Q, K
             10
           else
             value.to_i
           end
  end

  # correct for Aces
  values.select { |value| value == "A" }.count.times do
    sum -= 10 if sum > 21
  end

  sum
end

def busted?(cards)
  total(cards) > 21
end

# :tie, :dealer, :player, :dealer_busted, :player_busted
def detect_result(dealer_cards, player_cards)
  player_total = total(player_cards)
  dealer_total = total(dealer_cards)

  if player_total > 21
    :player_busted
  elsif dealer_total > 21
    :dealer_busted
  elsif dealer_total < player_total
    :player
  elsif dealer_total > player_total
    :dealer
  else
    :tie
  end
end

def display_result(dealer_cards, player_cards)
  case detect_result(dealer_cards, player_cards)
  when :player_busted
    prompt "You busted! Dealer wins!"
  when :dealer_busted
    prompt "Dealer busted! You win!"
  when :player
    prompt "You win!"
  when :dealer
    prompt "Dealer wins!"
  when :tie
    prompt "It's a tie!"
  end
end

def display_cards_and_totals(dealer_cards, player_cards)
  puts "=============="
  prompt "Dealer has #{dealer_cards}, for a total of: #{total(dealer_cards)}"
  prompt "Player has #{player_cards}, for a total of: #{total(player_cards)}"
  puts "=============="
end

def display_full_results(dealer_cards, player_cards)
  display_cards_and_totals(dealer_cards, player_cards)
  display_result(dealer_cards, player_cards)
end

def play_again?
  puts "-------------"
  prompt "Do you want to play again? (y or n)"
  answer = gets.chomp
  answer.downcase.start_with?("y")
end

def initialize_scores
  { "Player" => 0, "Dealer" => 0 }
end

def update_scores!(scores, dealer_cards, player_cards)
  case detect_result(dealer_cards, player_cards)
  when :player, :dealer_busted
    scores["Player"] += 1
  when :dealer, :player_busted
    scores["Dealer"] += 1
  end
end

def display_updated_scores(scores, dealer_cards, player_cards)
  update_scores!(scores, dealer_cards, player_cards)
  puts "-------------"
  puts "The score is:"
  scores.each do |competitor, score|
    puts "#{competitor} -- #{score}"
  end
end

def someone_won_game?(scores)
  !!detect_game_winner(scores)
end

def detect_game_winner(scores)
  if scores["Player"] == 5
    :player
  elsif scores["Dealer"] == 5
    :dealer
  end
end

def display_game_winner(scores)
  case detect_game_winner(scores)
  when :player
    prompt "Player won the game!"
  when :dealer
    prompt "Dealer won the game!"
  end
end

prompt "Welcome to Twenty-One!"

scores = initialize_scores

loop do
  # initialize vars
  deck = initialize_deck
  player_cards = []
  dealer_cards = []

  # initial deal
  2.times do
    player_cards << deck.pop
    dealer_cards << deck.pop
  end

  prompt "Dealer has #{dealer_cards[0]} and ?"
  player_total = total(player_cards)
  prompt "You have #{player_cards[0]} and #{player_cards[1]}, for a total of #{player_total}"

  # player turn
  loop do
    player_turn = nil
    loop do
      prompt "Would you like to hit (h) or stay (s)?"
      player_turn = gets.chomp.downcase
      break if ['h', 's'].include?(player_turn)
      prompt "Sorry, you must enter 'h' or 's'."
    end

    if player_turn == 'h'
      player_cards << deck.pop
      prompt "You chose to hit!"
      prompt "Your cards are now: #{player_cards}"
      player_total = total(player_cards) # total has changed, so update it
      prompt "Your total is now: #{player_total}"
    end

    break if player_turn == 's' || busted?(player_cards)
  end

  if busted?(player_cards)
    display_full_results(dealer_cards, player_cards)
    display_updated_scores(scores, dealer_cards, player_cards)
    break if someone_won_game?(scores)
    play_again? ? next : break
  else
    prompt "You stayed at #{player_total}"
  end

  # dealer turn
  prompt "Dealer turn..."

  loop do
    break if busted?(dealer_cards) || total(dealer_cards) >= 17

    prompt "Dealer hits!"
    dealer_cards << deck.pop
    prompt "Dealer's cards are now: #{dealer_cards}"
  end

  dealer_total = total(dealer_cards)
  if busted?(dealer_cards)
    prompt "Dealer total is now: #{dealer_total}"
    display_full_results(dealer_cards, player_cards)
    display_updated_scores(scores, dealer_cards, player_cards)
    break if someone_won_game?(scores)
    play_again? ? next : break
  else
    prompt "Dealer stays at #{dealer_total}"
  end

  # compare cards
  display_full_results(dealer_cards, player_cards)
  display_updated_scores(scores, dealer_cards, player_cards)

  break if someone_won_game?(scores)
  break unless play_again?
end

if someone_won_game?(scores)
  display_game_winner(scores)
end

prompt "Thank you for playing Twenty-One! Goodbye!"
