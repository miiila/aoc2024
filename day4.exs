Code.require_file("aoc.ex")

import AocHelper

defmodule Day4 do

  defp get_next({r, c}, :col) do
    for i <- 0..3, do: {r + i, c}
  end

  defp get_next({r, c}, :row) do
    for i <- 0..3, do: {r, c + i}
  end

  defp get_next({r, c}, :d1) do
    for i <- 0..3, do: {r + i, c + i}
  end

  defp get_next({r, c}, :d2) do
    for i <- 0..3, do: {r - i, c + i}
  end

  defp get_xmas(grid, {r,c}) do
    l = for t <- [:row, :col, :d1, :d2] do
      get_next({r,c}, t)
    end
    l
    |> Enum.map(&Enum.map(&1, fn t -> get_elem(grid, t) end))
    |> Enum.map(&Enum.join(&1, ""))
    |> Enum.count(fn s -> s == "XMAS" || s == "SAMX" end)
  end

  defp get_elem(grid, {r,c}) do
    case {r,c} do
      {r,c} when r < 0 -> ""
      {r,c} when  c < 0 -> ""
      {r,c} when r >= tuple_size(grid) -> ""
      {r,c} when c >= tuple_size(elem(grid, r)) -> ""
      _ -> elem(elem(grid, r), c)
    end

  end
  def solve_part_1(input) do
    for r <- 0..tuple_size(input)-1, c <- 0..tuple_size(elem(input, r))-1 do
      get_xmas(input, {r,c})
    end |> Enum.sum
  end

  def solve_part_2(input) do
    for r <- 0..tuple_size(input)-1, c <- 0..tuple_size(elem(input, r))-1 do
      case get_elem(input, {r,c}) do
        "A" -> 
          case {get_elem(input, {r-1, c-1}), get_elem(input, {r+1, c+1}), get_elem(input, {r-1, c+1}),get_elem(input, {r+1, c-1})} do
            {"S","M","S","M"} -> 1
            {"M","S","M","S"} -> 1
            {"M","S","S","M"} -> 1
            {"S","M","M","S"} -> 1
            _ -> 0
          end
        _ -> 0
      end
    end |> Enum.sum()
  end
end

transformer = fn line -> List.to_tuple(String.codepoints(line)) end
input = List.to_tuple(load_input(4, false, transformer))

IO.puts(Day4.solve_part_1(input))

IO.puts(Day4.solve_part_2(input))
