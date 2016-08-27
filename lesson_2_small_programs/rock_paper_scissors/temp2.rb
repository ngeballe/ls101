scores = {bill: 0, kate: 0}
bill_wins = 0
kate_wins = 0

def increase_score(player)
  scores[player] += 1
end

def add_one(variable)
  variable += 1
end

while true
  random = rand(100)
  if random > 50
    puts "The winner is Bill"
    #scores[:bill] += 1
    increase_score(:bill) # doesn't work
    add_one(bill_wins) # doesn't work
    #bill_wins += 1
  else
    puts "The winner is Kate"
    scores[:kate] += 1
    kate_wins += 1
  end
  puts "Bill has #{bill_wins} wins"
  puts "Kate has #{kate_wins} wins"
  puts "Scores: #{scores.inspect}"
  puts "Enter q to quit. Enter any other key to continue"
  break if gets.chomp == "q"
end
