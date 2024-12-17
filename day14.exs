Code.require_file("aoc.ex")

import AocHelper

defmodule Day14 do
  defp simulate({px, py}, {vx, vy}, seconds, x, y) do
    npx = rem(rem(px + vx * seconds, x) + x, x)
    npy = rem(rem(py + vy * seconds, y) + y, y)
    {npx, npy}
  end

  defp split_quad({px, py}, x, y) do
    cond do
      px in 0..(trunc(x / 2) - 1) && py in 0..(trunc(y / 2) - 1) -> 1
      px in (trunc(x / 2) + 1)..x && py in 0..(trunc(y / 2) - 1) -> 2
      px in 0..(trunc(x / 2) - 1) && py in (trunc(y / 2) + 1)..y -> 3
      px in (trunc(x / 2) + 1)..x && py in (trunc(y / 2) + 1)..y -> 4
      true -> 0
    end
  end

  defp draw(pos, gx, gy) do
    pic =
      for y <- 0..gy do
        for x <- 0..gx do
          if Enum.member?(pos, {x, y}) do
            "*"
          else
            "."
          end
        end
        |> Enum.join("")
      end
      |> Enum.join("\n")

    IO.puts(pic)
  end
  
  defp draw_if(pos, gx, gy, sec) do 
    #if Enum.any?(pos, fn {px, py} -> px == trunc(gx/2) && py == trunc(gy/2) end) do 
    draw(pos, gx, gy)
    IO.puts("\n#{sec} seconds\n\n")
    :timer.sleep(200)
  end

  def solve_part_1(input) do
    Enum.map(input, fn {p, v} ->
      simulate(p, v, 100, 101, 103)
    end)
    |> Enum.group_by(&split_quad(&1, 101, 103), fn _ -> 1 end)
    |> Map.drop([0])
    |> Map.values()
    |> Enum.map(&Enum.sum/1)
    |> Enum.product()
  end

  def solve_part_2(input) do
    for sec <- 5254..8000//101 do
    Enum.map(input, fn {p, v} ->
      simulate(p, v, sec, 101, 103)
    end)
    |> draw_if(101, 103, sec)
    end
  end
end

t = fn l ->
  [_ | t] = Regex.run(~r/p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)/, l)
  p = Enum.map(t, &String.to_integer/1)
  {{Enum.at(p, 0), Enum.at(p, 1)}, {Enum.at(p, 2), Enum.at(p, 3)}}
end

input = load_input(14, false, t)

IO.puts(Day14.solve_part_1(input))

IO.puts(Day14.solve_part_2(input))
