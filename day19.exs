Code.require_file("aoc.ex")

import AocHelper

defmodule Day19 do
  defp is_feasible?("", _, _, mem), do: {true, mem}

  defp is_feasible?(s, [], _, mem) do
    {false, Map.put(mem, s, false)}
  end

  defp is_feasible?(design, [pattern | r] = patterns, all_patterns, mem) do
    case m = Map.get(mem, design) do
      nil ->
        if String.starts_with?(design, pattern) do
          case is_feasible?(
                 String.slice(design, String.length(pattern)..String.length(design)),
                 all_patterns,
                 all_patterns,
                 mem
               ) do
            {true, mem} -> {true, Map.put(mem, design, true)}
            {false, mem} -> is_feasible?(design, r, all_patterns, mem)
          end
        else
          is_feasible?(design, r, all_patterns, mem)
        end

      m ->
        {m, mem}
    end
  end

  defp count_ways("", _, _, mem), do: {1, mem}

  defp count_ways(s, [], _, mem), do: {nil, Map.put(mem, s, nil)}

  defp count_ways(design, [pattern | r] = patterns, all_patterns, mem) do
    case m = Map.get(mem, design) do
      nil ->
        Enum.map_reduce(patterns, mem, fn pattern, mem ->
          if String.starts_with?(design, pattern) do
            case count_ways(
                   String.slice(design, String.length(pattern)..String.length(design)),
                   all_patterns,
                   all_patterns,
                   mem
                 ) do
              {nil, mem} -> count_ways(design, r, all_patterns, mem)
              {x, mem} -> {x, Map.update(mem, design, x, &(&1 + x))}
            end
          else
            {nil, mem}
          end
        end)
        |> then(fn {r, m} ->
          r = Enum.reject(r, &(&1 == nil)) |> Enum.sum()
          {r, m}
        end)

      m ->
        {m, mem}
    end
  end

  def solve_part_1(input) do
    [patterns | [_ | designs]] = input

    patterns =
      String.split(patterns, ", ")

    designs
    |> Enum.map(&is_feasible?(&1, patterns, patterns, Map.new()))
    |> Enum.count(&(elem(&1, 0) == true))
  end

  def solve_part_2(input) do
    [patterns | [_ | designs]] = input

    patterns =
      String.split(patterns, ", ")

    designs
    |> Enum.map(&count_ways(&1, patterns, patterns, Map.new()))
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum()
  end
end

input = load_input(19, false)

IO.puts(Day19.solve_part_1(input))

IO.puts(Day19.solve_part_2(input))
