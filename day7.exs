Code.require_file("aoc.ex")

import AocHelper

defmodule Day7 do
  defp is_valid?(target, curr, []) do
    target == curr
  end

  defp is_valid?(target, curr, _) when curr > target, do: false


  defp is_valid?(target, curr, [a | r ] = nums) do
    cond do 
      curr + Enum.sum(nums) == target -> true
      curr + Enum.reduce(nums, 1, fn acc, curr -> acc*curr end) == target -> true
      true -> Enum.any?([is_valid?(target, curr+a, r), is_valid?(target, curr*a, r)])
    end
  end

  defp is_valid2?(target, curr, []) do
    target == curr
  end

  defp is_valid2?(target, curr, _) when curr > target, do: false


  defp is_valid2?(target, curr, [a | r ] = nums) do
    cond do 
      curr + Enum.sum(nums) == target -> true
      curr + Enum.reduce(nums, 1, fn acc, curr -> acc*curr end) == target -> true
      true -> Enum.any?([is_valid2?(target, curr+a, r), is_valid2?(target, curr*a, r), is_valid2?(target, String.to_integer("#{Integer.to_string(curr)}#{Integer.to_string(a)}"), r)])
    end
  end


  def solve_part_1(input) do
    input 
    |> Enum.map(fn {t, nums} ->
      case is_valid?(t, 0, nums) do 
        true -> t
        false -> 0
      end
    end)
    |> Enum.sum
  end

  def solve_part_2(input) do
    input 
    |> Enum.map(fn {t, nums} ->
      case is_valid2?(t, 0, nums) do 
        true -> t
        false -> 0
      end
    end)
    |> Enum.sum
  end
end

t = fn l ->
  [target | [r | _]] = String.split(l, ":")
  r = String.trim_leading(r)

  r =
    String.split(r, " ")
    |> Enum.map(&String.to_integer/1)

  {String.to_integer(target), r}
end

input = load_input(7, false, t)

IO.puts(Day7.solve_part_1(input))

IO.puts(Day7.solve_part_2(input))
