content = Utils.getInput(5)
# content = String.trim("""
#     [D]   .
# [N] [C]   .
# [Z] [M] [P]
#  1   2   3

# move 1 from 2 to 1
# move 3 from 1 to 3
# move 2 from 2 to 1
# move 1 from 1 to 2
# """,
# "\n")

IO.puts(D05.part1(content))
IO.puts(D05.part2(content))
