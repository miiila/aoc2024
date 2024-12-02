Code.require_file("aoc.ex")

import AocHelper

defmodule Day2 do
  def solve_part_1(input) do
    reducer = fn line ->
      [_ | l1] = line
      Enum.zip_with(line, l1, fn a, b -> a - b end)
    end

    diffs = Enum.map(input, reducer)

    diffs
    |> Enum.count(fn l ->
      (Enum.all?(l, fn x -> x > 0 end) || Enum.all?(l, fn x -> x < 0 end)) &&
        Enum.all?(l, fn x -> 0 < abs(x) && abs(x) < 4 end)
    end)
  end

  def solve_part_2(input) do
    reducer = fn line ->
      [_ | l1] = line
      Enum.zip_with(line, l1, fn a, b -> a - b end)
    end

    diffs = Enum.map(input, reducer)

    pred = fn l ->
      (Enum.all?(l, fn x -> x > 0 end) || Enum.all?(l, fn x -> x < 0 end)) &&
        Enum.all?(l, fn x -> 0 < abs(x) && abs(x) < 4 end)
    end

    fails = Enum.map(diffs, pred)

    exp = fn {l,_} ->
      for index <- 0..(length(l) - 1) do
        List.delete_at(l, index)
      end
    end
    f = Enum.zip(input, fails)
      |> Enum.filter(fn {_, f} -> !f end)
      |> Enum.map(exp)
      |> Enum.map(fn l ->
        Enum.map(l, reducer)
        |> Enum.any?(pred)
    end)
    |>Enum.count(fn x -> x end)

    Enum.count(fails, fn x -> x end) + f

  end
end

input =
  load_input(2, false, fn x ->
    String.split(x, " ") |> Enum.map(&String.to_integer/1) |> Enum.to_list()
  end)

IO.puts(Day2.solve_part_1(input))
IO.puts(Day2.solve_part_2(input))
