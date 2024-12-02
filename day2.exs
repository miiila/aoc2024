Code.require_file("aoc.ex")

import AocHelper

defmodule Day2 do
  defp get_diffs([_ | t] = line) do
    Enum.zip_with(line, t, &(&1 - &2))
  end

  defp is_safe(l) do
    (Enum.all?(l, &(&1 > 0)) || Enum.all?(l, &(&1 < 0))) &&
      Enum.all?(l, &(abs(&1) in 1..3))
  end

  def solve_part_1(input) do
    input
    |> Enum.map(&get_diffs/1)
    |> Enum.count(&is_safe/1)
  end

  def solve_part_2(input) do
    diffs = Enum.map(input, &get_diffs/1)
    fails = Enum.map(diffs, &is_safe/1)

    f = input
      |> Enum.zip(fails)
      |> Enum.filter(fn {_, f} -> !f end)
      |> Enum.map(fn {l, _} -> 
        for index <- 0..(length(l) - 1), do: List.delete_at(l, index) 
        end)
      |> Enum.map(fn l ->
        Enum.map(l, &get_diffs/1)
        |> Enum.any?(&is_safe/1)
      end)
      |> Enum.count(& &1)

    Enum.count(fails, fn x -> x end) + f
  end
end

input =
  load_input(2, false, fn x ->
    String.split(x, " ") |> Enum.map(&String.to_integer/1) |> Enum.to_list()
  end)

IO.puts(Day2.solve_part_1(input))
IO.puts(Day2.solve_part_2(input))
