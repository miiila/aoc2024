Code.require_file("aoc.ex")

import AocHelper

defmodule Day11 do

  defp change_stone(0), do: 1

  defp change_stone(x) do
    y = Integer.to_string(x)
    l = String.length(y) 
    case rem(l,2) do 
      0 -> 
        {t1, t2} = String.split_at(y, trunc(l/2)) 
        [String.to_integer(t1), String.to_integer(t2)]
      _ -> x*2024
    end
  end

  defp solve_1(input, 75), do: length(input)

  defp solve_1(input, c) do
    Enum.map(input, &change_stone/1) |> List.flatten |> solve_1(c+1)
  end
  



  def solve_part_1(input) do
    solve_1(input, 0)
  end

  def solve_part_2(input) do

  end
end


[input | _]  = load_input(11, false)
input = Enum.map(String.split(input, " "), &String.to_integer/1)

IO.puts(Day11.solve_part_1(input))

IO.puts(Day11.solve_part_2(input))
