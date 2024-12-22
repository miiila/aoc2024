Code.require_file("aoc.ex")

import AocHelper

defmodule Day22 do
  defp mix(val, secret) do
    Bitwise.bxor(val, secret)
  end

  defp prune(secret) do
    rem(secret, 16_777_216)
  end

  def call_n_times(_, arg, 0), do: arg

  def call_n_times(func, arg, n) when n > 0 do
    call_n_times(func, func.(arg), n - 1)
  end

  defp calculate(secret) do
    mix(secret * 64, secret)
    |> prune
    |> then(&mix(trunc(&1 / 32), &1))
    |> then(&mix(&1 * 2048, &1))
    |> prune
  end

  defp find_sum(dp, seq) do 
    Enum.map(dp, &Map.get(&1, seq, 0)) |> Enum.sum
  end

  def solve_part_1(input) do
    Enum.map(input, fn x -> call_n_times(&calculate/1, x, 2000) end)
    |> Enum.sum()
  end

  def solve_part_2(input) do
    dp = Enum.map(input, fn x ->
      r =
        elem(
          Enum.map_reduce(0..2000, x, fn _, acc ->
            k = calculate(acc)
            {rem(k, 10), k}
          end),
          0
        )

      [_ | t] = r
      {r, Enum.zip_with(r, t, &(&2 - &1))}
    end)
    |> Enum.map(fn {prices, diffs} ->
      Enum.zip(Enum.chunk_every(diffs, 4, 1), Enum.slice(prices, 4..-1//1))
      |> Enum.reverse
      |> Map.new
    end)
    
    dp
    |> Enum.flat_map(&Map.keys/1)
    |> MapSet.new 
    |> Enum.map(&find_sum(dp, &1)) 
    |> Enum.max

  end
end

input = load_input(22, false, &String.to_integer/1)

IO.puts(Day22.solve_part_1(input))

IO.puts(Day22.solve_part_2(input))
