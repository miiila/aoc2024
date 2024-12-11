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

  defp solve_1(input, 25), do: length(input)

  defp solve_1(input, c) do
    Enum.map(input, &change_stone/1) |> List.flatten |> solve_1(c+1)
  end

  defp solve_2(i, 0, mem) do 
    {1, Map.put(mem, i, Map.put(Map.get(mem, i, %{}), 0, 1))}
  end

  defp solve_2(i, gen, mem) do 
    r = Map.get(Map.get(mem, i, %{}), gen, nil)
    case r do 
      nil -> 
        {rr,mem} = case k = change_stone(i) do 
          [k1, k2] ->
            {r1, mem}  = solve_2(k1, gen - 1, mem)
            {r2, mem} = solve_2(k2, gen - 1, mem)
            {r1 + r2,mem}
          kk -> 
            solve_2(kk, gen - 1, mem)
        end
        mem = Map.put(mem, i, Map.put(Map.get(mem, i, %{}), gen, rr))
        {rr, mem} 
      r -> 
        {r, mem}
    end
  end


  def solve_part_1(input) do
    solve_1(input, 0)
  end

  def solve_part_2(input) do
    {a,_} = Enum.map_reduce(input, %{}, fn k, acc ->
      solve_2(k, 75, acc) 
    end)
    Enum.sum(a)
  end
end


[input | _]  = load_input(11, false)
input = Enum.map(String.split(input, " "), &String.to_integer/1)

IO.puts(Day11.solve_part_1(input))

IO.puts(Day11.solve_part_2(input))
