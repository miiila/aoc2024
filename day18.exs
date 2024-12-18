Code.require_file("aoc.ex")

import AocHelper

defmodule Day18 do

  defp within_borders?({x, y}),
    do: x >= 0 && y >= 0 && x < 71 && y < 71

  defp in_queue?(queue, {p, s}) do 
    Enum.any?(queue, fn {pp, ss} -> pp == p && ss <= s end)
  end

  defp find_path(bytes_pos, queue, visited, current_min) do
    queue = Enum.sort(queue, fn {_, s1}, {_, s2} -> s1 < s2 end)

    case Enum.empty?(queue) do
      true ->
        current_min

      false ->
        [{{x, y}, steps} | queue] = queue

        current_min =
          if {x, y} == {70,70} do
            IO.puts(steps)
            min(steps, current_min)
          else
            current_min
          end

        new_queue =
          getNext({x, y})
          |> Enum.reject(fn p ->
            MapSet.member?(bytes_pos, p) || Map.get(visited, p, -1) > 0 ||
              steps > current_min || !within_borders?(p) || in_queue?(queue, {p, steps+1})
          end)
          |> Enum.reduce(queue, fn {nx, ny}, acc ->
            [{{nx, ny}, steps + 1} | acc]
          end)

        find_path(bytes_pos, new_queue, Map.put(visited, {x, y}, steps), current_min)
    end
  end

  def solve_part_1(input) do
    bytes_pos = Enum.take(input, 1024) |> MapSet.new
    find_path(bytes_pos, [{{0,0}, 0}], Map.new(), 100000000000)
  end

  def solve_part_2(input) do
    bytes_pos = Enum.take(input, 2915) |> MapSet.new
    find_path(bytes_pos, [{{0,0}, 0}], Map.new(), 100000000000)
    List.last(Enum.take(input, 2915))

  end
end

input = load_input(18, false, fn l -> 
  String.split(l, ",") 
  |> Enum.map(&String.to_integer/1)
  |> List.to_tuple
end)

IO.puts(Day18.solve_part_1(input))

IO.puts(Day18.solve_part_2(input))
