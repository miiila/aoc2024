Code.require_file("aoc.ex")

import AocHelper

defmodule Day21 do
  defp solve_numeric(cur, target, keys) do
    {r1, c1} = Map.get(keys, cur)
    {r2, c2} = Map.get(keys, target)

    sorting_hat = %{"^" => 1, ">" => 2, "v" => 3, "<" => 2, "A" => 10}

    dr =
      case r1 - r2 do
        0 -> ""
        x when x < 0 -> String.duplicate("v", abs(x))
        x when x > 0 -> String.duplicate("^", abs(x))
      end

    dc =
      case c1 - c2 do
        0 -> ""
        x when x < 0 -> String.duplicate(">", abs(x))
        x when x > 0 -> String.duplicate("<", abs(x))
      end

    nav =
      Enum.join(String.codepoints(Enum.join([dr, dc, "A"])))
  end

  def solve_part_1(input) do
    numeric = %{
      "7" => {0, 0},
      "8" => {0, 1},
      "9" => {0, 2},
      "4" => {1, 0},
      "5" => {1, 1},
      "6" => {1, 2},
      "1" => {2, 0},
      "2" => {2, 1},
      "3" => {2, 2},
      nil => {3, 0},
      "0" => {3, 1},
      "A" => {3, 2}
    }

    directional = %{
      nil => {0, 0},
      "^" => {0, 1},
      "A" => {0, 2},
      "<" => {1, 0},
      "v" => {1, 1},
      ">" => {1, 2}
    }

    res =
      input
      |> Enum.map(fn l ->
        l
        |> String.codepoints()
        |> solve_sequence(numeric)
        |> solve_sequence(directional)
        |> solve_sequence(directional)
        |> dbg
      end)
      |> Enum.map(&Enum.count/1)

    dbg(res)

    rn =
      input
      |> Enum.map(&Regex.run(~r/(\d+)A/, &1))
      |> Enum.map(fn [_ | [n | _]] -> String.to_integer(n) end)

    IO.inspect(res, charlists: :as_list)
    # dbg([res, rn])
    Enum.zip_reduce(res, rn, 0, fn x, y, acc -> acc + x * y end)
  end

  defp solve_sequence(seq, keypad) do
    ["A" | seq]
    |> Enum.chunk_every(2, 1)
    |> Enum.reduce("", fn l, acc ->
      case l do
        [s | [t | _]] -> acc <> solve_numeric(s, t, keypad)
        _ -> acc
      end
    end)
    |> String.codepoints()
  end

  def solve_part_2(input) do
  end
end

input = load_input(21, true)

IO.inspect(Day21.solve_part_1(input), charlists: :as_list)

IO.puts(Day21.solve_part_2(input))
