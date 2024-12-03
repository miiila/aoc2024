Code.require_file("aoc.ex")

import AocHelper

defmodule Day3 do

  def solve_part_1(input) do
    pattern = ~r/mul\((\d+),(\d+)\)/
    input
    |> Enum.join(" ")
    |> then(&Regex.scan(pattern, &1, capture: :all))
    |> Enum.map(fn [_ | [x,y]] -> String.to_integer(x) * String.to_integer(y) end)
    |> Enum.sum()
  end

  def solve_part_2(input) do
    pattern = ~r/mul\((\d+),(\d+)\)/
    input
    |> Enum.join(" ")
    |> String.replace("do()", "\ndo()")
    |> String.replace("don't()", "\ndon't()")
    |> String.split("\n")
    |> Enum.reject(fn s -> String.starts_with?(s, "don't()") end)
    |> Enum.join(" ")
    |> then(&Regex.scan(pattern, &1, capture: :all))
    |> Enum.map(fn [_ | [x,y]] -> String.to_integer(x) * String.to_integer(y) end)
    |> Enum.sum()
    
  end
end

input = load_input(3, false)

IO.puts(Day3.solve_part_1(input))

IO.puts(Day3.solve_part_2(input))
