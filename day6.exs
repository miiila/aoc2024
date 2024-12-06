Code.require_file("aoc.ex")

import AocHelper

defmodule Day6 do
  defp find_start(grid, {r, c}) when c == tuple_size(elem(grid, r)),
    do: find_start(grid, {r + 1, 0})

  defp find_start(grid, {r, c}) do
    case elem(elem(grid, r), c) do
      "^" -> {r, c}
      _ -> find_start(grid, {r, c + 1})
    end
  end

  defp get_next_dir({-1, 0}), do: {0, 1}
  defp get_next_dir({0, 1}), do: {1, 0}
  defp get_next_dir({1, 0}), do: {0, -1}
  defp get_next_dir({0, -1}), do: {-1, 0}

  defp walk_until(grid, {r, c}, _, visited) when c == tuple_size(elem(grid, r)), do: visited
  defp walk_until(_, {_, c}, _, visited) when c < 0, do: visited
  defp walk_until(grid, {r, _}, _, visited) when r == tuple_size(grid), do: visited
  defp walk_until(_, {r, _}, _, visited) when r < 0, do: visited

  defp walk_until(grid, {r, c}, {dr, dc}, visited) when elem(elem(grid, r + dr), c + dc) == "#",
    do: walk_until(grid, {r, c}, get_next_dir({dr, dc}), visited)

  defp walk_until(grid, {r, c}, {dr, dc}, visited) do
    walk_until(grid, {r + dr, c + dc}, {dr, dc}, MapSet.put(visited, {r, c}))
  end

  defp is_cycle?(grid, {r, c}, _, _) when c == tuple_size(elem(grid, r)), do: false
  defp is_cycle?(_, {_, c}, _, _) when c < 0, do: false
  defp is_cycle?(grid, {r, _}, _, _) when r == tuple_size(grid), do: false
  defp is_cycle?(_, {r, _}, _, _) when r < 0, do: false

  defp is_cycle?(grid, {r, c}, {dr, dc}, visited) when elem(elem(grid, r + dr), c + dc) == "#",
    do: is_cycle?(grid, {r, c}, get_next_dir({dr, dc}), visited)

  defp is_cycle?(grid, {r, c}, {dr, dc}, visited) do
    case MapSet.member?(visited, {{r, c}, {dr, dc}}) do
      true -> true
      _ -> is_cycle?(grid, {r + dr, c + dc}, {dr, dc}, MapSet.put(visited, {{r, c}, {dr, dc}}))
    end
  end

  defp add_block(grid, {r, c}) do
    row = elem(grid, r)
    new_r = put_elem(row, c, "#")
    put_elem(grid, r, new_r)
  end

  def solve_part_1(input) do
    start = find_start(input, {0, 0})

    walk_until(input, start, {-1, 0}, MapSet.new([start]))
    |> MapSet.size()
  end

  def solve_part_2(input) do
    start = find_start(input, {0, 0})

    walk_until(input, start, {-1, 0}, MapSet.new([start]))
    |> MapSet.delete(start)
    |> Enum.map(&is_cycle?(add_block(input, &1), start, {-1, 0}, MapSet.new([start, {-1, 0}])))
    |> Enum.count(&(&1))
  end
end

transformer = fn line -> List.to_tuple(String.codepoints(line)) end
input = List.to_tuple(load_input(6, false, transformer))

IO.puts(Day6.solve_part_1(input))

IO.puts(Day6.solve_part_2(input))
