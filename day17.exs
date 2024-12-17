Code.require_file("aoc.ex")

import AocHelper

defmodule Day17 do
  defp get_combo_operand(operand, registers) do
    case operand do
      x when x in 0..3 -> x
      4 -> elem(registers, 0)
      5 -> elem(registers, 1)
      6 -> elem(registers, 2)
      7 -> throw(7)
    end
  end

  defp run_instruction(0, operand, registers, ins_pointer, output) do
    {put_elem(
       registers,
       0,
       trunc(elem(registers, 0) / :math.pow(2, get_combo_operand(operand, registers)))
     ), ins_pointer + 2, output}
  end

  defp run_instruction(1, operand, registers, ins_pointer, output) do
    {put_elem(registers, 1, Bitwise.bxor(elem(registers, 1), operand)), ins_pointer + 2, output}
  end

  defp run_instruction(2, operand, registers, ins_pointer, output) do
    {put_elem(registers, 1, rem(get_combo_operand(operand, registers), 8)), ins_pointer + 2,
     output}
  end

  defp run_instruction(3, operand, registers, ins_pointer, output) do
    case elem(registers, 0) do
      0 -> {registers, ins_pointer + 2, output}
      _ -> {registers, operand, output}
    end
  end

  defp run_instruction(4, operand, registers, ins_pointer, output) do
    {put_elem(registers, 1, Bitwise.bxor(elem(registers, 1), elem(registers, 2))),
     ins_pointer + 2, output}
  end

  defp run_instruction(5, operand, registers, ins_pointer, output) do
    {registers, ins_pointer + 2, [rem(get_combo_operand(operand, registers), 8) | output]}
  end

  defp run_instruction(6, operand, registers, ins_pointer, output) do
    {put_elem(
       registers,
       1,
       trunc(elem(registers, 0) / :math.pow(2, get_combo_operand(operand, registers)))
     ), ins_pointer + 2, output}
  end

  defp run_instruction(7, operand, registers, ins_pointer, output) do
    {put_elem(
       registers,
       2,
       trunc(elem(registers, 0) / :math.pow(2, get_combo_operand(operand, registers)))
     ), ins_pointer + 2, output}
  end

  defp run_program(program, ins_pointer, registers, output)
       when ins_pointer >= tuple_size(program),
       do: output

  defp run_program(program, ins_pointer, registers, output) do
    {registers, ins_pointer, output} =
      run_instruction(
        elem(program, ins_pointer),
        elem(program, ins_pointer + 1),
        registers,
        ins_pointer,
        output
      )

    run_program(program, ins_pointer, registers, output)
  end

  def solve_part_1(input) do
    registers = {65_804_993, 0, 0}
    program = {2, 4, 1, 1, 7, 5, 1, 4, 0, 3, 4, 5, 5, 5, 3, 0}

    run_program(program, 0, registers, [])
    |> Enum.reverse()
    |> Enum.join(",")
  end

  def solve_part_2(input) do
    program = {2, 4, 1, 1, 7, 5, 1, 4, 0, 3, 4, 5, 5, 5, 3, 0}

    # 35184372088832
    # 107912092000000
    # 281474976710656
    for i <- 202322936867370..trunc(:math.pow(8,16))//1 do
      res = run_program(program, 0, {i,0,0}, [])
      |> Enum.reverse()
      |> Enum.join(",")
      IO.inspect({i, res, "#{:math.pow(8,16)-i} to go"})
      #if String.at(res,0) == String.at("2,4,1,1,7,5,1,4,0,3,4,5,5,5,3,0", 0) , do: throw(i)
      if res == Enum.join(Tuple.to_list(program), ",") do 
        throw (i)
      end
    end
  end
end

input = load_input(17, false)

IO.puts(Day17.solve_part_1(input))

IO.puts(Day17.solve_part_2(input))
