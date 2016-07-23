flintstones = %w(Fred Barney Wilma Betty BamBam Pebbles)

flintstones.concat(["Dino", "Hoppy"])
# or flintstones += ["Dino", "Hoppy"]

p flintstones


# official answer--better style:
flintstones.concat(%w(Dino Hoppy))
