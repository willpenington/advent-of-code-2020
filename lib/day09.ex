defmodule AdventOfCode.Day09 do
  @moduledoc ~S"""
  Advent of Code Day 9: Encoding Error

  Finds values based on what they do or don't add up to in a squence of numbers.
  """

  alias AdventOfCode.Util

  @day_number 9

  @doc ~S"""
  Calculate and print the answers to both parts of the question
  """
  @spec process() :: :ok
  def process() do
    data = load_data()

    part1 = part1(data)
    part2 = part2(data)

    IO.puts("Part 1: #{part1}, Part 2: #{part2}")
  end

  @doc ~S"""
  Find the first number that isn't a the sum of one of the previous 25 values
  """
  @spec part1([integer()]) :: integer()
  def part1(data) do
    {preamble, code} = Enum.split(data, 25)

    summing_pairs(preamble, code)
    |> Enum.find_value(fn
      {value, []} -> value
      _ -> nil
    end)
  end

  @doc ~S"""
  Find the sum of the smallest and largest numbers in the first sequence of numbers that adds up
  to the answer of part 1.
  """
  @spec part2([integer()]) :: integer()
  def part2(data) do
    target = part1(data)
    find_weakness(data, target)
  end

  @spec summing_pairs_helper([integer()], [integer()]) :: [{integer(), [{integer(), integer()}]}]
  defp summing_pairs_helper(_, []), do: []

  defp summing_pairs_helper(values, [target | tail]) do
    # x < y makes this more predictable for the sake of testing
    pairs =
      for x <- values, y <- values, x + y == target, x < y do
        {x, y}
      end

    preamble = [target | Enum.take(values, length(values) - 1)]

    [{target, pairs} | summing_pairs_helper(preamble, tail)]
  end

  @doc ~S"""
  Find all the pairs of numbers in a rolling preceding window that sum to each value in the list.

  The intial window is provided as the first argument and the list is provided as the second argument.
  As each number is checked the first entiy in the list of values to try and sum will be dropped and
  the number will be added to the end.

  ## Examples

      iex> AdventOfCode.Day09.summing_pairs([40, 62, 55, 65, 95], [102, 117, 150, 182, 127, 219])
      [
        {102, [{40, 62}]},
        {117, [{55, 62}]},
        {150, [{55, 95}]},
        {182, [{65, 117}]},
        {127, []},
        {219, [{102, 117}]}
      ]

  """
  @spec summing_pairs([integer()], [integer()]) :: [{integer(), [{integer(), integer()}]}]
  def summing_pairs(preamble, sequence) do
    # This helper logic could be avoided but reversing the preamble makes the list manipulation
    # easier to follow in the main flow
    Enum.reverse(preamble)
    |> summing_pairs_helper(sequence)
  end

  @spec find_weakness_helper(integer(), [integer()], integer(), integer(), integer()) :: integer() | nil
  defp find_weakness_helper(acc, [val | tail], smallest, largest, target) do
    case acc + val do
      ^target ->
        smallest + largest

      x when x < target ->
        find_weakness_helper(x, tail, min(val, smallest), max(val, largest), target)

      _ ->
        nil
    end
  end

  @doc ~S"""
  Find the sum of the smallest and largest numbers in the first sub-sequence found in `values` that
  adds up to `target`.

  ## Examples

  In this example the sequence runs from 20 to 40, the smallest number is 15 and the largest is 47
  giving a total of 62:

      iex> AdventOfCode.Day09.find_weakness([35, 20, 15, 25, 47, 40, 62, 55, 65, 95, 102, 117, 150], 127)
      62
  """
  @spec find_weakness([integer()], integer()) :: integer()
  def find_weakness(values, target)

  def find_weakness([val | tail], target) do
    case find_weakness_helper(val, tail, val, val, target) do
      nil -> find_weakness(tail, target)
      x -> x
    end
  end

  @doc ~S"""
  Load and parse the list of numbers from the input file.
  """
  @spec load_data() :: [integer()]
  def load_data() do
    Util.find_input(@day_number)
    |> Util.load_line_delimited_input()
    |> Enum.map(&String.to_integer/1)
  end
end
