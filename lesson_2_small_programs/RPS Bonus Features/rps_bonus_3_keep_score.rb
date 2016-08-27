require "pry"

CHOICE_SHORTCUTS_TO_WORDS = { "r" => "rock", "p" => "paper",
                              "s" => "scissors", "l" => "lizard",
                              "sp" => "spock" }
CHOICE_SHORTCUTS = CHOICE_SHORTCUTS_TO_WORDS.keys
CHOICE_WORDS = CHOICE_SHORTCUTS_TO_WORDS.values
PLAYER_1_WIN_CONDITIONS = [
  %w(rock scissors), %w(rock lizard), %w(paper rock), %w(paper spock),
  %w(scissors paper), %w(scissors lizard), %w(lizard spock), %w(lizard paper),
  %w(spock rock), %w(spock scissors)
]

computer_score = 0
player_score = 0

def display_choices
  s = "Choose one: "
  CHOICE_SHORTCUTS_TO_WORDS.each do |shortcut, word|
    s << "'#{shortcut}' for '#{word}', "
  end
  s[-2..-1] = "" # chop off ", " at end
  puts s
end

def prompt(message)
  Kernel.puts("=> #{message}")
end

def player1_wins?(player1, player2)
  PLAYER_1_WIN_CONDITIONS.include?([player1, player2])
end

def pluralize(number, word)
  if number == 1
    "1 #{word}"
  else
    "#{number} #{word}s"
  end
end

def validate_input(options)
  loop do
    input = gets.chomp
    break input if options.include?(input)
    prompt("Invalid entry. Please enter one of the folowing: #{options}.")
  end
end

def display_scores(player_score, computer_score)
  prompt("You have #{pluralize(player_score, 'point')}; \
    the computer has #{pluralize(computer_score, 'point')}.")
end

def decide_winner(player, computer)
  if player1_wins?(player, computer)
    :player
  elsif player1_wins?(computer, player)
    :computer
  else
    :tie
  end
end

def display_results(winner)
  case winner
  when :player
    prompt("You won!")
  when :computer
    prompt("Computer won.")
  when :tie
    prompt("It's a tie.")
  end
end

prompt("Welcome to the Rock/Paper/Scissors/Lizard/Spock \
  All-Star Battle Royale. First player to gain five points wins.")

loop do
  choice = ''
  loop do
    display_choices()
    choice = Kernel.gets().chomp()
    if CHOICE_SHORTCUTS.include?(choice)
      break
    else
      prompt("That's not a valid choice.")
    end
  end
  choice = CHOICE_SHORTCUTS_TO_WORDS[choice] # convert to full word

  computer_choice = CHOICE_WORDS.sample

  Kernel.puts("You chose: #{choice}; Computer chose: #{computer_choice}")

  winner = decide_winner(choice, computer_choice)

  display_results(winner)

  player_score += 1 if winner == :player
  computer_score += 1 if winner == :computer

  display_scores(player_score, computer_score)

  if computer_score == 5
    prompt("Computer won the game. Better luck next time, old chap.")
    break
  elsif player_score == 5
    prompt("You won the game. Congratulations, my friend!")
    break
  end

  prompt("Do you want to play again? (yes/no)")
  answer = validate_input(%w(yes no))
  break if answer == "no"
end

prompt("Thank you for playing. Goodbye!")
