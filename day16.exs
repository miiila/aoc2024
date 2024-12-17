Code.require_file("aoc.ex")

import AocHelper

defmodule Day16 do
  defp find_path(grid, queue, visited, current_max, path_set) do
    queue = Enum.sort(queue, fn {_, s1, _, _}, {_, s2, _, _} -> s1 < s2 end)

    case Enum.empty?(queue) do
      true ->
        {current_max, MapSet.size(path_set)}

      false ->
        [{{r, c}, steps, dir, path} | queue] = queue

        {current_max, path_set} =
          if elem(elem(grid, r), c) == "E" do
            {min(steps, current_max), MapSet.union(path_set, path)}
          else
            {current_max, path_set}
          end

        new_queue =
          getNext({r, c}, :dir)
          |> Enum.reject(fn {{nr, nc}, nd} ->
            elem(elem(grid, nr), nc) == "#" || Map.get(visited, {nr, nc, nd}) < steps ||
              steps > current_max
          end)
          |> Enum.reduce(queue, fn {{nr, nc}, nd}, acc ->
            upd =
              if dir == nd do
                1
              else
                1001
              end

            [{{nr, nc}, steps + upd, nd, MapSet.put(path, {r, c})} | acc]
          end)

        find_path(grid, new_queue, Map.put(visited, {r, c, dir}, steps), current_max, path_set)
    end
  end

  defp find_start(grid, {r, c}) when c == tuple_size(elem(grid, r)),
    do: find_start(grid, {r + 1, 0})

  defp find_start(grid, {r, c}) do
    case elem(elem(grid, r), c) do
      "S" -> {r, c}
      _ -> find_start(grid, {r, c + 1})
    end
  end

  def solve_part_1(input) do
    start = find_start(input, {0, 0})

    {len, _} =
      find_path(
        input,
        [{start, 0, ">", MapSet.new()}],
        MapSet.new(),
        10_000_000_000_000,
        MapSet.new([start])
      )

    len
  end

  def solve_part_2(input) do
    start = find_start(input, {0, 0})

    {_, len} =
      find_path(
        input,
        [{start, 0, ">", MapSet.new()}],
        MapSet.new(),
        10_000_000_000_000,
        MapSet.new([start])
      )

    len + 1
  end
end

transformer = fn line -> List.to_tuple(String.codepoints(line)) end
input = List.to_tuple(load_input(16, false, transformer))

IO.puts(Day16.solve_part_1(input))

IO.puts(Day16.solve_part_2(input))
