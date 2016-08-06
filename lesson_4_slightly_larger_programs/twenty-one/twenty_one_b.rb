require 'pry'

# incorporating tips

SUITS = ["H", "D", "C", "S"].freeze
VALUES = (2..10).to_a.map(&:to_s) + %w(J Q K A).flatten

def full_name(card_value)
  mapping = { "J" => "Jack", "Q" => "Queen",
              "K" => "King", "A" => "Ace" }
  mapping.include?(card_value) ? mapping[card_value] : card_value
end

def points(card)
  case card
  when "2".."10"
    card.to_i
  when "J", "Q", "K"
    10
  end
end

def prompt(message)
  puts "=> #{message}"
end

def initialize_deck
  deck = []
  SUITS.each do |suit|
    VALUES.each do |value|
      deck << [value, suit]
    end
  end
  deck.shuffle
end

def deal_card!(deck, hand)
  card = deck.shift
  hand << card
end

def show_player_hand(player_hand)
  cards = player_hand.map { |value, _| full_name(value) }
  prompt "You have: #{joinand(cards)}"
end

def show_dealer_hand(dealer_hand, hide_second_card=true)
  cards = dealer_hand.map { |value, _| full_name(value) }
  if hide_second_card
    prompt "The dealer has: #{cards[0]} and unknown card"
  else
    prompt "The dealer has: #{joinand(cards)}"
  end
end

def total(hand)
  total = 0
  card_values = hand.map { |card| card[0] }
  aces, non_aces = card_values.partition { |value| value == "A" }
  total = non_aces.map { |card| points(card) }.reduce(:+)
  aces.each do
    total += if toal > 10
               1
             else
               11
             end
  end
  total
end

def busted?(hand)
  total(hand) > 21
end

def find_winner(player_hand, dealer_hand)
  if busted?(player_hand)
    "Dealer"
  elsif busted?(dealer_hand)
    "Player"
  elsif total(dealer_hand) > total(player_hand)
    "Dealer"
  elsif total(player_hand) > total(dealer_hand)
    "Player"
  elsif total(player_hand) == total(dealer_hand)
    nil
  end
end

def display_results(winner)
  case winner
  when "Dealer"
    prompt "The dealer won."
  when "Player"
    prompt "You won."
  when nil
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

loop do
  deck = initialize_deck

  player_hand = []
  dealer_hand = []

  2.times { deal_card!(deck, player_hand) }
  2.times { deal_card!(deck, dealer_hand) }

  # # player turn
  player_choice = nil
  loop do
    show_player_hand(player_hand)
    show_dealer_hand(dealer_hand)
    prompt "Do you want to hit or stay?"
    player_choice = gets.chomp
    break if player_choice == "stay"
    if player_choice == "hit"
      deal_card!(deck, player_hand)
      break if busted?(player_hand)
      next
    end
    prompt "Sorry, that's not a valid choice."
  end

  if busted?(player_hand)
    show_player_hand(player_hand)
    show_dealer_hand(dealer_hand, false)
    prompt "You busted. The dealer won."
  else
    prompt "You chose to stay."
    # show_dealer_hand(dealer_hand)
    loop do
      break if total(dealer_hand) >= 17
      deal_card!(deck, dealer_hand)
    end
    show_player_hand(player_hand)
    puts "Your total is #{total(player_hand)}"
    show_dealer_hand(dealer_hand, false)
    puts "The dealer's total is #{total(dealer_hand)}"
    if busted?(dealer_hand)
      prompt "The dealer busted. You won!"
    else
      prompt "The dealer chose to stay."
      winner = find_winner(player_hand, dealer_hand)
      display_results(winner)
    end
  end
  prompt "Do you want to play again?"
  answer = gets.chomp
  break unless answer.downcase.start_with?("y")
  system "clear"
end

prompt "Goodbye! Until next time! Thanks for playing."
