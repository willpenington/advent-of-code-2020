defmodule AdventOfCode.Day08 do
  @moduledoc ~S"""
  Advent of Code Day 8: A basic interpreter

  Implements a basic interpreter which has some problems with getting trapped
  in infinte loops. The instructions have a type and a single numerical value
  and the interpreter keeps an accumulator value that starts at 0 and is
  returned when the program completes.

  The instructions supported are:
    - `nop <value>`: Do nothing and advance to the next instruction. The value is ignored.
    - `acc <value>`: Add `<value>` to the accumulator and advance to the next instruction.
    - `jmp <value>`: Move `<value>` instructions forward (or backwards for negative numbers).
  """

  alias AdventOfCode.Util

  @day_number 8

  @typedoc """
  Valid operation codes for the program.

  Opcodes are stored as atoms for readability.
  """
  @type opcode :: :nop | :acc | :jmp
  @typedoc """
  Program instructions

  All operations have a common structure of an opcode and an integer value.
  Values can be positive or negative and there is no known restriction on their
  size.

  `:nop` operations don't use the value but it must be retained as it is
  important for recovering corrupted programs.
  """
  @type instruction :: {opcode(), integer()}

  @doc ~S"""
  Calculate and print the answers to both parts of the question
  """
  def process() do
    instructions = load_data()

    part1 = part1(instructions)
    part2 = part2(instructions)

    IO.puts("Part 1: #{part1}, Part 2: #{part2}")
  end

  @doc ~S"""
  Calculate the answer to part 1

  Get the value of the accumulator when the program enters an infinite loop.
  """
  @spec part1([instruction()]) :: integer()
  def part1(instructions) do
    {:loop, acc, _pc} = execute(instructions)
    acc
  end

  @doc ~S"""
  Calculate the answers to part 2

  Get the value of the accumualtor when the program runs to completion after
  swapping a single instruction from `jmp` to `nop` or vice versa.
  """
  @spec part2([instruction()]) :: integer()
  def part2(instructions) do
    {_, result} = find_swap(instructions)
    result
  end

  @doc ~S"""
  Load and parse instructions from the input file.
  """
  @spec load_data() :: [instruction()]
  def load_data() do
    Util.find_input(@day_number)
    |> Util.load_line_delimited_input()
    |> Enum.map(&parse_line/1)
  end

  @doc ~S"""
  Parse a line of input into a structured tuple

  ## Examples

      iex> AdventOfCode.Day08.parse_line("jmp +32")
      {:jmp, 32}

      iex> AdventOfCode.Day08.parse_line("nop -5")
      {:nop, -5}
  """
  @spec parse_line(String.t()) :: instruction()
  def parse_line(<<instruction::binary-size(3), " ", value::binary>>) do
    case instruction do
      "jmp" -> {:jmp, String.to_integer(value)}
      "acc" -> {:acc, String.to_integer(value)}
      "nop" -> {:nop, String.to_integer(value)}
    end
  end

  @spec execute_internal([instruction()], integer(), integer(), [integer()]) :: {({:loop, integer(), integer()} | {:term, integer()}), [integer()]}
  defp execute_internal(instructions, acc, pc, seen) do
    if pc in seen do
      {{:loop, acc, pc}, seen}
    else
      seen = [pc | seen]

      case Enum.at(instructions, pc) do
        {:nop, _} -> execute_internal(instructions, acc, pc + 1, seen)
        {:acc, value} -> execute_internal(instructions, acc + value, pc + 1, seen)
        {:jmp, value} -> execute_internal(instructions, acc, pc + value, seen)
        # Assume any access outside the bounds of instructions is terminating, lazy but it works
        nil -> {{:term, acc}, seen}
      end
    end
  end

  @doc ~S"""
  Execute a program and return the value of the accumulator and whether or not it completed sucessfully.

  When an instruction is encountered for a second time, the execution will stop and `{:loop, accumulator, index}`
  will be returned where `accumulator` is the value of the accumlator before the instruction is executed again and
  `index` is the location of the instruction that would be repeated in `instructions`.

  If the program completes sucessfully `{:term, accumulator}` will be returned where `accumulator` is the final value
  of the accumulator.

  ## Examples

      iex> AdventOfCode.Day08.execute([{:nop, 0}, {:acc, 1}, {:jmp, 4}, {:acc, 3}, {:jmp, -3}, {:acc, -99}, {:acc, 1}, {:jmp, -4}, {:acc, 6}])
      {:loop, 5, 1}

      iex> AdventOfCode.Day08.execute([{:nop, 0}, {:acc, 1}, {:jmp, 4}, {:acc, 3}, {:jmp, -3}, {:acc, -99}, {:acc, 1}, {:nop, -4}, {:acc, 6}])
      {:term, 8}

  """
  @spec execute([instruction()]) :: {:loop, integer(), integer()} | {:term, integer()}
  def execute(instructions) do
    {result, _trace} = execute_internal(instructions, 0, 0, [])
    result
  end

  @doc ~S"""
  Get a trace of the instructions processed while executing a program by offset into the
  list of instructions.

  ## Examples

      iex> AdventOfCode.Day08.trace([{:nop, 0}, {:acc, 1}, {:jmp, 4}, {:acc, 3}, {:jmp, -3}, {:acc, -99}, {:acc, 1}, {:jmp, -4}, {:acc, 6}])
      [0, 1, 2, 6, 7, 3, 4]
  """
  @spec trace([instruction()]) :: [integer()]
  def trace(instructions) do
    {_result, trace} = execute_internal(instructions, 0, 0, [])
    Enum.reverse(trace)
  end

  @spec swap_instruction(instruction()) :: instruction()
  defp swap_instruction({:jmp, val}), do: {:nop, val}
  defp swap_instruction({:nop, val}), do: {:jmp, val}

  @doc """
  Find the instruction that needs to be swapped for a program complete sucessfully.

  `jmp` and `nop` instructions will be swapped, `acc` will be ignored.

  ## Examples

      iex> AdventOfCode.Day08.find_swap([{:nop, 0}, {:acc, 1}, {:jmp, 4}, {:acc, 3}, {:jmp, -3}, {:acc, -99}, {:acc, 1}, {:jmp, -4}, {:acc, 6}])
      {7, 8}
  """
  @spec find_swap([instruction()]) :: {integer(), integer()}
  def find_swap(instructions) do
    # Start by tracing the unaltered program because only one instruction is modified so
    # it must be in the original program's flow. Possibly overkill, but it only adds one
    # execution and potentially saves sevaral.
    trace(instructions)
    |> Enum.find_value(fn location ->
      case Enum.at(instructions, location) do
        {:acc, _} ->
          nil

        {inst, val} ->
          List.replace_at(instructions, location, swap_instruction({inst, val}))
          |> execute()
          |> case do
            {:loop, _, _} ->
              nil

            {:term, result} ->
              {location, result}
          end
      end
    end)
  end
end
