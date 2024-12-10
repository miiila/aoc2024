Code.require_file("aoc.ex")

import AocHelper

defmodule Day10 do
  defp find_hike(grid, _, target, _, p) when target == 0 do
    res =
      for r <- 0..(tuple_size(grid) - 1) do
        for c <- 0..(tuple_size(elem(grid, 0)) - 1) do
          if elem(elem(grid, r), c) == target do
            {r, c}
          end
        end
        |> Enum.filter(& &1)
      end
      |> List.flatten()
      |> Enum.map(&(find_hike(grid, &1, 1, [&1], p)) |> MapSet.new |> MapSet.size)
  end

  defp find_hike(_, pos, target, res, :part2) when target == 10, do: res

  defp find_hike(_, pos, target, res, _) when target == 10, do: pos


  defp find_hike(grid, pos, target, res, p) when target == 9 do
    getNext(pos)
    |> Enum.filter(fn {r, c} ->
      r >= 0 && r < tuple_size(grid) && c >= 0 && c < tuple_size(elem(grid, r))
    end)
    |> Enum.filter(fn {r, c} -> elem(elem(grid, r), c) == target end)
    |> Enum.map(&find_hike(grid, &1, target + 1, [&1 | res], p))
  end

  defp find_hike(grid, pos, target, res, p) do
    getNext(pos)
    |> Enum.filter(fn {r, c} ->
      r >= 0 && r < tuple_size(grid) && c >= 0 && c < tuple_size(elem(grid, r))
    end)
    |> Enum.filter(fn {r, c} -> elem(elem(grid, r), c) == target end)
    |> Enum.flat_map(&find_hike(grid, &1, target + 1, [&1 | res], p))
  end

  def solve_part_1(input) do
    input
    |> find_hike(0, 0, [], :part1)
    |> Enum.sum
  end

  def solve_part_2(input) do
    input
    |> find_hike(0, 0, [], :part2)
    |> Enum.sum
  end
end

transformer = fn line ->
  List.to_tuple(String.codepoints(line) |> Enum.map(&String.to_integer/1))
end

input = List.to_tuple(load_input(10, false, transformer))

IO.puts(Day10.solve_part_1(input))

IO.puts(Day10.solve_part_2(input))
