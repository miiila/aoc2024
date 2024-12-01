import AocHelper

defmodule Day1 do
  def solve_part_1(input) do
    [first, second] = input

    first
    |> Enum.sort()
    |> Enum.zip(Enum.sort(second))
    |> Enum.map(fn {f, s} -> abs(f - s) end)
    |> Enum.sum()
  end

  def solve_part_2(input) do
    [first, second] = input
    second_freq = Enum.frequencies(second)
    Enum.reduce(first, 0, fn x, acc -> acc + x * Map.get(second_freq, x, 0) end)
  end
end

input = load_input(1, false, fn l -> String.split(l, "   ") |> Enum.map(&String.to_integer/1) end)

input =
  Enum.reduce(input, [[], []], fn [f, s], [acc_f, acc_s] ->
    [[f | acc_f], [s | acc_s]]
  end)

IO.puts(Day1.solve_part_1(input))

IO.puts(Day1.solve_part_2(input))
