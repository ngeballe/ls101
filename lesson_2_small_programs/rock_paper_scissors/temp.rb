scores = {bill: 0, kate: 0}
bill_wins = 0
kate_wins = 0

while true
  random = rand(100)
  if random > 50
    puts "The winner is Bill"
    scores[:bill] += 1
    bill_wins += 1
  else
    puts "The winner is Kate"
    scores[:kate] += 1
    kate_wins += 1
  end
  puts "Bill has #{bill_wins} wins"
  puts "Kate has #{kate_wins} wins"
  puts "Scores: #{scores.inspect}"
  puts "Enter q to quit. Enter any other key to continue."
  break if gets.chomp == "q"
end