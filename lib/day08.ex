defmodule AdventOfCode.Day08 do
  alias AdventOfCode.Util

  @day_number 8

  def process() do
    IO.puts("Part 1: #{part1()}, Part 2: #{part2()}")
  end

  def part1() do
    {:loop, acc, _pc} = load_data()
    |> execute()
    acc
  end

  def part2() do
    {_location, result} = load_data()
    |> find_swap(0)
    result
  end

  defp execute_internal(instructions, acc, pc, seen) do
    if MapSet.member?(seen, pc) do
        {:loop, acc, pc}
    else
      seen = MapSet.put(seen, pc)
      case Enum.at(instructions, pc) do
        {:nop, _} -> execute_internal(instructions, acc, pc + 1, seen)
        {:acc, value} -> execute_internal(instructions, acc + value, pc + 1, seen)
        {:jmp, value} -> execute_internal(instructions, acc, pc + value, seen)
        nil -> {:term, acc}
      end
    end
  end

  def execute(instructions) do
    execute_internal(instructions, 0, 0, MapSet.new())
  end

  defp swap_instruction({:jmp, val}), do: {:nop, val}
  defp swap_instruction({:nop, val}), do: {:jmp, val}

  def find_swap(instructions, location \\ 0) do
    case Enum.at(instructions, location) do
      {:acc, _} -> find_swap(instructions, location + 1)
      {inst, val} ->
        List.replace_at(instructions, location, swap_instruction({inst, val}))
        |> execute()
        |> case do
          {:loop, _, _} -> find_swap(instructions, location + 1)
          {:term, result} -> {location, result}
        end
    end
  end

  def load_data() do
    Util.find_input(@day_number)
    |> Util.load_line_delimited_input()
    |> Enum.map(&parse_line/1)
  end

  def parse_line(<<instruction::binary-size(3), " ", value::binary>>) do
    case instruction do
      "jmp" -> {:jmp, String.to_integer(value)}
      "acc" -> {:acc, String.to_integer(value)}
      "nop" -> {:nop, String.to_integer(value)}
    end
  end

end
