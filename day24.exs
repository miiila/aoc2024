Code.require_file("aoc.ex")

import AocHelper
import Bitwise

defmodule Day24 do
  defp solve(vals, []) do 
    vals
  end

  defp solve(vals, [{a,b,op, t} = conn | conns]) do 
    case {Map.get(vals, a, nil), Map.get(vals, b, nil)} do 
      {nil, nil} -> solve(vals, Enum.reverse([conn | Enum.reverse(conns)]))
      {_, nil} -> solve(vals, Enum.reverse([conn | Enum.reverse(conns)]))
      {nil, _} -> solve(vals, Enum.reverse([conn | Enum.reverse(conns)]))
      {a, b} -> solve(Map.put(vals,t,op.(a,b)), conns)
    end
  end

  def solve_part_1(vals, conns) do
    vals = solve(vals, conns)
    Enum.filter(vals, fn {k,v} -> String.starts_with?(k, "z") end)
    |> Enum.sort
    |> Enum.reverse
    |> Enum.reduce(0, fn {k,v}, acc -> (acc <<< 1) ||| v end)
  end

  def solve_part_2(input) do
  end

  def parse_conn(conn, t) do
    [a | [op | [b | _]]] = String.split(conn)

    op =
      case op do
        "AND" -> &Bitwise.band/2
        "OR" -> &Bitwise.bor/2
        "XOR" -> &Bitwise.bxor/2
      end

    {a, b, op, t}
  end
end

input = load_input(24, false)
{vals, [_ | conns]} = Enum.split_while(input, &(&1 != ""))

vals =
  Enum.map(vals, &String.split(&1, ": "))
  |> Enum.map(fn [a | [b | _]] -> {a, String.to_integer(b)} end)
  |> Map.new()


conns =
  Enum.map(conns, &(String.split(&1, " -> ") |> List.to_tuple()))
  |> Enum.map(fn {a, b} ->
    Day24.parse_conn(a,b)
  end)

IO.puts(Day24.solve_part_1(vals,conns))

IO.puts(Day24.solve_part_2(input))
