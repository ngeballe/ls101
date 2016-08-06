require 'pry'

# SUITS = %w(hearts diamonds clubs spades)
VALUES = (2..10).to_a.map { |n| n.to_s } + %w(Jack Queen King Ace).flatten

def points(card)
  case card 
  when "2".."10"
    card.to_i
  when "Jack", "Queen", "King"
    10
  end
end

def prompt(message)
  puts "=> #{message}"
end

def initialize_deck
  deck = []
  VALUES.each do |value|
    4.times { deck << value }
  end
  deck.shuffle # :)
end

def deal_card!(recipient, deck, hands)
  card = deck.sample
  deck.delete(card)
  hands[recipient] << card
end

def show_hands(hands, end_of_game=false)
  dealer_hand = hands[:dealer]
  player_hand = hands[:player]
  if end_of_game
    puts "Dealer has: #{joinand(dealer_hand)} for a total of #{points_in_hand(dealer_hand)}"
    puts "You have: #{joinand(player_hand)} for a total of #{points_in_hand(player_hand)}"
  else
    puts "Dealer has: #{joinand(dealer_hand[0..-2])} and unknown card"
    puts "You have: #{joinand(player_hand)}"
  end
end

def points_in_hand(hand)
  points = 0
  num_aces = hand.count("Ace")
  aces, non_aces = hand.partition { |card| card == "Ace" }
  points = non_aces.map { |card| points(card) }.reduce(0, :+)
  aces.each do |ace|
    if points + 11 > 21
      # puts "Ace counted as 1"
      points += 1
    else
      # puts "Ace counted as 11"
      points += 11
    end
  end
  points
end

def bust?(hand)
  points_in_hand(hand) > 21
end

def find_winner(hands)
  player_hand, dealer_hand = hands[:player], hands[:dealer]
  player_points = points_in_hand(player_hand)
  dealer_points = points_in_hand(dealer_hand)
  if bust?(player_hand)
    "Deadler"
  elsif bust?(dealer_hand)
    "Player"
  elsif player_points > dealer_points
    "Player"
  elsif dealer_points > player_points
    "Dealer"
  elsif dealer_points == player_points
    "Tie"
  end
end

def display_winner(winner)
  case winner
  when "Dealer"
    prompt "The dealer won."
  when "Player"
    prompt "You won."
  when "Tie"
    prompt "It's a tie."
  end
end

def joinand(arr, delimiter=', ', word='and')
  arr = arr.dup
  arr[-1] = "#{word} #{arr.last}" if arr.size > 1
  arr.size == 2 ? arr.join(' ') : arr.join(delimiter)
end

system "clear"
prompt "Welcome to Twenty-One!"

deck = initialize_deck
hands = { player: [], dealer: [] }

2.times { deal_card!(:player, deck, hands) }
2.times { deal_card!(:dealer, deck, hands) }

# player turn
player_choice = ''
loop do
  show_hands(hands)
  prompt "Do you want to hit or stay?"
  player_choice = gets.chomp
  case player_choice
  when "hit"
    deal_card!(:player, deck, hands)
    break if bust?(hands[:player])
  when "stay"
    break
  else
    prompt "Sorry, that's not a valid choice."
  end
end

puts
if bust?(hands[:player])
  puts "You busted. The dealer won."
  puts
  winner = "Dealer"
  show_hands(hands, true)
else
  # dealer turn
  loop do
    show_hands(hands, true)   
    if points_in_hand(hands[:dealer]) < 17
      puts "Dealer chose hit"
      deal_card!(:dealer, deck, hands)
      break if bust?(hands[:dealer])
    else
      puts "Dealer chose stay"
      break
    end
  end
  puts
  if bust?(hands[:dealer])
    winner = "Player"
    puts "The dealer busted. You won!"
    puts
    show_hands(hands, true)
  else
    # compare hands
    winner = find_winner(hands)
    prompt "Dealer has: #{hands[:dealer].join(", ")}"
    prompt "The dealer's hand adds up to #{points_in_hand(hands[:dealer])}"
    prompt "You have: #{hands[:player].join(", ")}"
    prompt "Your hand adds up to #{points_in_hand(hands[:player])}"

    display_winner(winner)
  end
end
