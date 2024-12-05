Code.require_file("aoc.ex")

import AocHelper

defmodule Day5 do
  defp in_order?(update, rules) do 
    update
    |> Enum.map_reduce( MapSet.new([]), fn page, visited -> 
      in_order = 0 == rules 
      |> Map.get( page, nil)
      |> MapSet.intersection(visited)
      |> MapSet.size
      {in_order, MapSet.put(visited, page)}
    end)
    |> then(&Enum.all?(elem(&1,0)))
  end

  defp get_rules_and_updates(input) do 
    {rules, [_ | updates]} = Enum.split_while(input, fn x -> x != nil end)

    rules =
      Enum.reduce(rules, %{}, fn {k, v}, acc ->
        Map.update(acc, k, MapSet.new([v]), fn set ->
          MapSet.put(set, v)
        end)
      end)

    {rules, updates}
  end


  def solve_part_1(input) do
    {rules, updates} = get_rules_and_updates(input)
    updates
    |> Enum.map(fn u -> 
      case in_order?(u, rules) do 
        true -> Enum.at(u, trunc(length(u)/2))
        false -> 0
      end
    end)
    |> Enum.sum()
  end

  def solve_part_2(input) do
    {rules, updates} = get_rules_and_updates(input)
    updates
    |> Enum.reject(&in_order?(&1, rules))
    |> Enum.map(&Enum.sort(&1, fn a, b ->
      MapSet.member?(Map.get(rules,a), b) && !MapSet.member?(Map.get(rules,b), a)
    end))
    |> Enum.map(&Enum.at(&1, trunc(length(&1)/2)))
    |> Enum.sum()
  end
end

t = fn l ->
  cond do
    l == "" ->
      nil

    String.contains?(l, "|") ->
      Enum.map(String.split(l, "|"), &String.to_integer/1) |> List.to_tuple()

    true ->
      Enum.map(String.split(l, ","), &String.to_integer/1)
  end
end

input = load_input(5, false, t)

IO.puts(Day5.solve_part_1(input))

IO.puts(Day5.solve_part_2(input))
