Code.require_file("aoc.ex")

import AocHelper

defmodule Day20 do
  def find_start(grid, {r, c}) when c == tuple_size(elem(grid, r)),
    do: find_start(grid, {r + 1, 0})

  def find_start(grid, {r, c}) do
    case elem(elem(grid, r), c) do
      "S" -> {r, c}
      _ -> find_start(grid, {r, c + 1})
    end
  end

  def find_path(grid, pos, res, steps) do
    res = Map.put(res, pos, steps)

    next =
      getNext(pos)
      |> Enum.reject(fn {r, c} -> elem(elem(grid, r), c) == "#" || {r, c} in Map.keys(res) end)
      |> List.first()

    case next do
      nil -> res
      _ -> find_path(grid, next, res, steps + 1)
    end
  end

  defp find_cheat(path, pos, 1, orig_time) do
    next =
      getNext(pos)
      |> Enum.filter(fn p -> p in Map.keys(path) end)
      |> Enum.map(fn p -> Map.get(path, p) - orig_time - 2 end)
      |> Enum.filter(fn r -> r > 0 end)
  end

  defp find_cheat(path, pos, lim, orig_time) do
    next =
      getNext(pos)
       |> Enum.reject(fn p -> p in Map.keys(path) end)
      |> Enum.map(fn p -> find_cheat(path, p, lim - 1, orig_time) end)
      |> List.flatten()
  end

  def solve_part_1(path) do
    path
    |> Enum.map(fn {p, t} -> find_cheat(path, p, 2, t) end)
    |> List.flatten()
    |> Enum.count(&(&1 >= 100))

  end

  def solve_part_2(path) do

    path
    |> Enum.reduce({[], MapSet.new()}, fn {{r, c}, t}, {res, visited} ->
      rr =
        Enum.filter(Map.keys(path), fn {nr, nc} ->
          abs(r - nr) + abs(c - nc) > 0 && abs(r - nr) + abs(c - nc) <= 20 &&
            {nr, nc} not in visited
        end)
        |> Enum.map(fn {nr, nc} = p ->
          abs(Map.get(path, p) - t) - (abs(r - nr) + abs(c - nc))
        end)
        |> Enum.reject(&(&1 < 100))

      {List.flatten([rr | res]), MapSet.put(visited, {r, c})}
    end)
    |> then(&elem(&1, 0))
    |> Enum.count(&(&1 >= 100))
  end
end

transformer = fn line -> List.to_tuple(String.codepoints(line)) end
input = List.to_tuple(load_input(20, false, transformer))
start = Day20.find_start(input, {0, 0})
path = Day20.find_path(input, start, Map.new(), 0)

IO.puts(Day20.solve_part_1(path))

IO.puts(Day20.solve_part_2(path))
