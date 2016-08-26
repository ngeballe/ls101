VALID_CHOICES = %w(rock paper scissors lizard spock)
PLAYER_1_WIN_CONDITIONS = [
  %w(rock scissors), %w(rock lizard), %w(paper rock), %w(paper spock),
  %w(scissors paper), %w(scissors lizard), %w(lizard spock), %w(lizard paper),
  %w(spock rock), %w(spock scissors)
]

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
