require "pry"

CHOICE_SHORTCUTS_TO_WORDS = { "r" => "rock", "p" => "paper",
                              "s" => "scissors", "l" => "lizard",
                              "sp" => "spock" }
CHOICE_SHORTCUTS = CHOICE_SHORTCUTS_TO_WORDS.keys
CHOICE_WORDS = CHOICE_SHORTCUTS_TO_WORDS.values

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
  (player1 == "rock" && player2 == "scissors") ||
    (player1 == "rock" && player2 == "lizard") ||
    (player1 == "paper" && player2 == "rock") ||
    (player1 == "paper" && player2 == "spock") ||
    (player1 == "scissors" && player2 == "paper") ||
    (player1 == "scissors" && player2 == "lizard") ||
    (player1 == "lizard" && player2 == "spock") ||
    (player1 == "lizard" && player2 == "paper") ||
    (player1 == "spock" && player2 == "rock") ||
    (player1 == "spock" && player2 == "scissors")
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

  prompt("Do you want to play again?")
  answer = Kernel.gets().chomp()
  break unless answer.downcase().start_with?("y")
end

prompt("Thank you for playing. Goodbye!")
