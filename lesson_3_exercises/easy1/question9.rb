# Given the hash below

flintstones = { "Fred" => 0, "Wilma" => 1, "Barney" => 2, "Betty" => 3, "BamBam" => 4, "Pebbles" => 5 }

# Turn this into an array containing only two elements: Barney's name and Barney's number

ans = flintstones.detect { |name, number| name == "Barney" }
p ans

# official, better answer
ans = flintstones.assoc("Barney")
p ans

