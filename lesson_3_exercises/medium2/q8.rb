# Question 8

# Consider these two simple methods:

def foo(param = "no")
  "yes"
end

def bar(param = "no")
  param == "no" ? "yes" : "no"
end

# What would be the output of this code:

bar(foo)

# Answer: "no"
# foo returns yes, so bar(foo) = bar("yes").
# bar("yes") returns "no" since "param == 'no'" is false.

puts bar(foo)