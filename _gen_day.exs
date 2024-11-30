Code.require_file("aoc.ex")
import AocHelper

[day]  = System.argv()

template = ~s"""
Code.require_file("aoc.ex")

import AocHelper

defmodule Day#{day} do

  def solve_part_1(input) do

  end

  def solve_part_2(input) do

  end
end

input = load_input(#{day}, false)

IO.puts(Day#{day}.solve_part_1(input))

IO.puts(Day#{day}.solve_part_2(input))
"""

download_input(day)

File.write!("./day#{day}.exs", template)
