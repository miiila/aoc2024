Code.require_file("aoc.ex")

import AocHelper

defmodule Day8 do
  defp antinode_pos(a1, a2, start, limit) do
    Enum.reduce(a2, MapSet.new(), fn a, acc ->
      rd = elem(a1, 0) - elem(a, 0)
      cd = elem(a1, 1) - elem(a, 1)

      for l <- start..limit do
        n1 = {elem(a1, 0) + rd * l, elem(a1, 1) + cd * l}
        n2 = {elem(a, 0) - rd * l, elem(a, 1) - cd * l}
        [n1, n2]
      end
      |> List.flatten()
      |> then(&MapSet.union(acc, MapSet.new(&1)))
    end)
  end

  defp count_antinodes([a1 | [_ | []] = r], start, limit) do
    antinode_pos(a1, r, start, limit)
  end

  defp count_antinodes([a1 | r], start, limit) do
    MapSet.union(antinode_pos(a1, r, start, limit), count_antinodes(r, start, limit))
  end

  def(solve_part_1(input)) do
    parse_input(input)
    |> Map.values()
    |> Enum.map(&count_antinodes(&1, 1, 1))
    |> Enum.reduce(fn s, acc ->
      MapSet.union(s, acc)
    end)
    |> Enum.count(fn {r, c} ->
      r >= 0 && c >= 0 && r < length(input) && c < length(input)
    end)
  end

  def solve_part_2(input) do
    parse_input(input)
    |> Map.values()
    |> Enum.map(&count_antinodes(&1, 0, 50))
    |> Enum.reduce(fn s, acc ->
      MapSet.union(s, acc)
    end)
    |> Enum.count(fn {r, c} ->
      r >= 0 && c >= 0 && r < length(input) && c < length(input)
    end)
  end

  defp parse_input(input) do
    input
    |> Enum.with_index(fn line, row ->
      String.codepoints(line)
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {val, col}, acc ->
        case val do
          "." ->
            acc

          _ ->
            Map.update(acc, val, [{row, col}], fn l ->
              [{row, col} | l]
            end)
        end
      end)
    end)
    |> Enum.reduce(fn map, acc ->
      Map.merge(acc, map, fn _k, v1, v2 -> v1 ++ v2 end)
    end)
  end
end

input = load_input(8, false)

IO.puts(Day8.solve_part_1(input))

IO.puts(Day8.solve_part_2(input))
