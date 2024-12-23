Code.require_file("aoc.ex")

import AocHelper

defmodule Day23 do
  defp make_graph(input) do
    Enum.reduce(input, %{}, fn {f, t}, g ->
      g
      |> Map.update(f, MapSet.new([t]), &MapSet.put(&1, t))
      |> Map.update(t, MapSet.new([f]), &MapSet.put(&1, f))
    end)
  end

  defp has_edge(g, f, t) do
    MapSet.member?(Map.get(g, f), t)
  end

  defp find_triplets(g, f) do
    Map.get(g, f)
    |> Enum.map(fn t ->
      Map.get(g, t)
      |> Enum.filter(&has_edge(g, &1, f))
      |> Enum.map(&MapSet.new([f, t, &1]))
    end)
    |> List.flatten()
    |> MapSet.new()
  end

  def solve_part_1(input) do
    g = make_graph(input)

    Enum.reduce(Map.keys(g), MapSet.new(), fn n, acc ->
      MapSet.union(find_triplets(g, n), acc)
    end)
    |> Enum.count(fn x -> Enum.any?(x, &String.starts_with?(&1, "t")) end)
  end

  def solve_part_2(input) do
    g = make_graph(input)

    Enum.map(g, fn {k, v} ->
      Enum.reduce(v, %{}, fn n, acc ->
        Enum.reduce(Map.get(g, n), Map.update(acc, n, 1, &(&1 + 1)), fn nn, accc ->
          Map.update(accc, nn, 1, &(&1 + 1))
        end)
      end)
    end)
    |> Enum.map(fn x -> Enum.filter(x, fn y -> Enum.max(Map.values(x)) - elem(y, 1) < 2 end) end)
    # Heuristic based on ouput examination
    |> Enum.filter(fn x -> Enum.count(x) == 13 end)
    |> List.first()
    |> Enum.map(&elem(&1, 0))
    |> Enum.sort()
    |> Enum.join(",")
  end
end

input = load_input(23, false, &(String.split(&1, "-") |> List.to_tuple()))

IO.puts(Day23.solve_part_1(input))

IO.puts(Day23.solve_part_2(input))
