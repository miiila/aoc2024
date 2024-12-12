Code.require_file("aoc.ex")

import AocHelper

defmodule Day12 do
  defp within_borders?({r, c}, grid),
    do: r >= 0 && c >= 0 && r < tuple_size(grid) && c < tuple_size(elem(grid, r))

  defp find_plot(grid, {r, c}, curr, {ar, per}) do
    if elem(elem(grid, r), c) != curr do
      {ar, per, grid}
    else
      nexts = getNext({r, c})
      per = per + Enum.count(nexts, fn p -> !within_borders?(p, grid) end)
      nexts = Enum.filter(nexts, fn p -> within_borders?(p, grid) end)
      nexts = Enum.reject(nexts, fn {nr, nc} -> elem(elem(grid, nr), nc) == "@" end)
      per = per + Enum.count(nexts, fn {nr, nc} -> elem(elem(grid, nr), nc) != curr end)
      nexts = Enum.filter(nexts, fn {nr, nc} -> elem(elem(grid, nr), nc) == curr end)
      ngrid = put_elem(grid, r, put_elem(elem(grid, r), c, "@"))
      ar = ar + 1

      case length(nexts) do
        0 ->
          {ar, per, ngrid}

        _ ->
          Enum.reduce(nexts, {ar, per, ngrid}, fn np, {a, p, ng} = acc ->
            find_plot(ng, np, curr, {a, p})
          end)
      end
    end
  end

  defp find_plots(input) do
    List.flatten(for r <- 0..tuple_size(input)-1 do
      List.flatten(for c <- 0..tuple_size(elem(input, r))-1 do
        {r,c}
      end)
    end)
    |> Enum.reduce({[], input}, fn {r,c}, {res, grid} -> 
      curr = elem(elem(grid, r),c)
      if curr == "." do 
        {res, grid}
      else
        {ar, per, ngrid} = find_plot(grid, {r,c}, curr, {0,0})
        ngrid = List.to_tuple(for r <- 0..tuple_size(input)-1 do
              List.to_tuple(for c <- 0..tuple_size(elem(input, r))-1 do
                case k = elem(elem(ngrid,r),c) do 
                  "@" -> "."
                    k -> k
                end
              end)
            end)
        {[{ar, per} | res], ngrid}
      end
    end)
  end

  def solve_part_1(input) do
    {res, rgrid} = find_plots(input)
    res
    |> Enum.map(fn {a,b} -> a * b end)
    |> Enum.sum
  end

  def solve_part_2(input) do
  end
end

transformer = fn line -> List.to_tuple(String.codepoints(line)) end
input = List.to_tuple(load_input(12, false, transformer))

IO.puts(Day12.solve_part_1(input))

IO.puts(Day12.solve_part_2(input))
