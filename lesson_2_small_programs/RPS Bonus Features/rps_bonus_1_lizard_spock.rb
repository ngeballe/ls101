VALID_CHOICES = %w(rock paper scissors lizard spock)

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
    prompt("Choose one: #{VALID_CHOICES.join(', ')}")
    choice = Kernel.gets().chomp()
    if VALID_CHOICES.include?(choice)
      break
    else
      prompt("That's not a valid choice.")
    end
  end

  computer_choice = VALID_CHOICES.sample

  Kernel.puts("You chose: #{choice}; Computer chose: #{computer_choice}")

  display_results(choice, computer_choice)

  prompt("Do you want to play again?")
  answer = Kernel.gets().chomp()
  break unless answer.downcase().start_with?("y")
end

prompt("Thank you for playing. Goodbye!")
