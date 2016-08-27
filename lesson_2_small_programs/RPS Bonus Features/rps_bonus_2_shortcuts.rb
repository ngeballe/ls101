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

def say_choices
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

def display_results(player, computer)
  if player1_wins?(player, computer)
    prompt("You won!")
  elsif player1_wins?(computer, player)
    prompt("Computer won.")
  else
    prompt("It's a tie.")
  end
end

def validate_input(options)
  loop do
    input = gets.chomp
    break input if options.include?(input)
    prompt("Invalid entry. Please enter one of the folowing: #{options}.")
  end
end

loop do
  choice = ''
  loop do
    say_choices()
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

  display_results(choice, computer_choice)

  prompt("Do you want to play again? (yes/no)")
  answer = validate_input(%w(yes no))
  break if answer == "no"
end

prompt("Thank you for playing. Goodbye!")
