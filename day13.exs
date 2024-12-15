Code.require_file("aoc.ex")

import AocHelper

defmodule Day13 do
  defp find_prize(ins) do
    [{ax, ay} | [{bx, by} | [{tx, ty} | _]]] = ins

    for i <- 0..100 do
      case r = rem(tx - i * ax, bx) do
        0 ->
          j = trunc((tx - i * ax) / bx)

          if i * ay + j * by == ty do
            {i, j}
          else
            nil
          end

        _ ->
          nil
      end
    end
    |> Enum.filter(&(&1 != nil))
  end

  defp find_prize(ins, :two) do
    # cramer rule found on the reddit and wiki /shrug 
    [{a1, a2} | [{b1, b2} | [{c1, c2} | _]]] = ins
    c1 = c1 + 10000000000000
    c2 = c2 + 10000000000000
    s1 = (c1*b2-b1*c2)/(a1*b2-b1*a2)
    s2 = (a1*c2-c1*a2)/(a1*b2-b1*a2)
    if Float.ceil(s1) != trunc(s1) || Float.ceil(s2) != trunc(s2) do
      nil
    else
      {trunc(s1), trunc(s2)}
    end
  end



  def solve_part_1(input) do
    Enum.chunk_every(input, 3)
    |> Enum.map(&find_prize/1)
    |> Enum.reject(&Enum.empty?/1)
    |> Enum.map(&(Enum.map(&1, fn {x, y} -> 3 * x + y end) |> Enum.min()))
    |> Enum.sum()
  end

  def solve_part_2(input) do
    Enum.chunk_every(input, 3)
    |> Enum.map(&find_prize(&1, :two))
    |> Enum.reject(&(&1 == nil))
    |> Enum.map(fn {x, y} -> 3 * x + y end)
    |> Enum.sum()
  end
end

t = fn line ->
  case k = Regex.run(~r/.*X[+=](\d+), Y[+=](\d+)/, line) do
    nil ->
      nil

    k ->
      [_ | [x | [y | _]]] = k
      {String.to_integer(x), String.to_integer(y)}
  end
end

input = load_input(13, false, t) |> Enum.filter(&(&1 != nil))

IO.puts(Day13.solve_part_1(input))

IO.puts(Day13.solve_part_2(input))
