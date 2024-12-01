Code.require_file("aoc.ex")

import AocHelper

defmodule Day1 do
  def solve_part_1(input) do
    [first, second] = input
    Enum.zip(Enum.sort(first), Enum.sort(second))
    |> Enum.map(fn {f, s} -> f - s end)
    |> Enum.map(&abs/1)
    |> Enum.sum()
  end

  def solve_part_2(input) do
    [first, second] = input
    Enum.map(first, fn x -> x * Enum.count(for y <- second, y == x, do: y) end) |> Enum.sum
  end
end

input = load_input(1, false, fn l -> String.split(l, "   ") |> Enum.map(&String.to_integer/1) end)
input = Enum.reduce(input, [[], []], fn [f | [s | _]], [acc_f, acc_s] ->
        [[f | acc_f], [s | acc_s]]
      end)

IO.puts(Day1.solve_part_1(input))

IO.puts(Day1.solve_part_2(input))
