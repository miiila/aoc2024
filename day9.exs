Code.require_file("aoc.ex")

import AocHelper

defmodule Day9 do
  defp solve(queue, res) do
    case :queue.out(queue) do
      {:empty, _} ->
        res
      {{:value, {empty_len, id} = x}, q} when id == -1 and empty_len == 0 ->
        solve(q, res)

      {{:value, {empty_len, id} = x}, q} when id == -1 ->
        {{_, {end_len, end_id}}, q} = :queue.out_r(q)

        {end_len, end_id, q} =
          if end_id == -1 do
            {{_, {end_len, end_id}}, q} = :queue.out_r(q)
            {end_len, end_id, q}
          else
            {end_len, end_id, q}
          end


        diff = empty_len - end_len

        cond do
          diff == 0 ->
            solve(q, [{end_len, end_id} | res])

          diff > 0 ->
            q = :queue.in_r({diff, -1}, q)
            solve(q, [{end_len, end_id} | res])

          diff < 0 ->
            q = :queue.in({abs(diff), end_id}, q)
            solve(q, [{empty_len, end_id} | res])
        end

      {{:value, {empty_len, id} = x}, q} ->
        solve(q, [x | res])
    end
  end

  defp solve2(tup, index) when index < 0 do 
    Tuple.to_list(tup)
  end

  defp solve2(tup, index) do 
    {csize, cid} = x = elem(tup, index)
    case cid do 
      -1 -> solve2(tup, index-1)
      _ ->
        i = Enum.find_index(Tuple.to_list(tup), fn {size, id} -> size >= csize && id == -1 end)
        cond do
          i == nil -> solve2(tup, index-1)
          i > index -> solve2(tup, index-1)
          true -> 
            tup = put_elem(tup, index, {csize, -1})
            |> Tuple.insert_at(i, x)
            res = if csize == elem(elem(tup,i+1), 0) do 
                Tuple.delete_at(tup, i+1)
              else
                put_elem(tup, i+1, {elem(elem(tup, i+1),0) - csize, -1})
            end
            solve2(res, index)
        end
    end
  end

  def solve_part_1(input) do
    files = Enum.take_every(input, 2) |> Enum.with_index()
    empty = Enum.take_every([-1 | input], 2)
    [_ | empty] = empty |> Enum.map(&{&1, -1})

    q =
      Enum.zip(files, empty)
      |> Enum.flat_map(fn {a, b} -> [a, b] end)
      |> Enum.concat([List.last(files)])

    q = :queue.from_list(q)
    solve(q, []) 
    |> Enum.reverse
    |> Enum.flat_map(fn {l, id} -> 
      for _ <- 1..l, do: id 
      end)
    |> Enum.with_index
    |> Enum.map(fn {c, id} -> c*id end)
    |> Enum.sum
  end

  def solve_part_2(input) do
    files = Enum.take_every(input, 2) |> Enum.with_index()
    empty = Enum.take_every([-1 | input], 2)
    [_ | empty] = empty |> Enum.map(&{&1, -1})

    q =
      Enum.zip(files, empty)
      |> Enum.flat_map(fn {a, b} -> [a, b] end)
      |> Enum.concat([List.last(files)])
      |> Enum.reject(fn {a,b} -> a == 0 && b == -1 end)
      |> List.to_tuple

    solve2(q, tuple_size(q) -1)
    |> Enum.flat_map(fn {l, id} -> 
      for _ <- 1..l, do: id 
      end)
    |> Enum.with_index
    |> Enum.map(fn {c, id} -> 
      c = if c < 0 do 
        0
      else
        c
      end
      c*id end)
    |> Enum.sum
  end
end

input = load_input(9, false)
input = List.first(input) |> String.codepoints() |> Enum.map(&String.to_integer/1)

IO.puts(Day9.solve_part_1(input))

IO.puts(Day9.solve_part_2(input))
