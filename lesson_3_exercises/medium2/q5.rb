# Question 5

# What is the output of the following code?

answer = 42

def mess_with_it(some_number)
  some_number += 8
end

new_answer = mess_with_it(answer)

p answer - 8

# 42

# wrong! 34. I knew the method didn't mutate answer, but I stupidly misread p answer - 8 as p new_answer - 8.